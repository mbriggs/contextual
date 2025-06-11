require "json"

data = JSON.parse(File.read("coverage/.resultset.json"))
puts "Available sections:"
data.each_key { |k| puts "  #{k}" }
puts

["Unit Tests", "Minitest"].each do |section|
  next unless data[section] && data[section]["coverage"]

  total_lines = 0
  covered_lines = 0
  files = 0

  puts "=== #{section} ==="
  data[section]["coverage"].each do |file, info|
    lines = info["lines"]
    countable_lines = lines.count { |l| !l.nil? }
    covered = lines.count { |l| l && l.positive? }

    next unless countable_lines.positive?

    files += 1
    total_lines += countable_lines
    covered_lines += covered

    short_name = file.split("/").last(3).join("/")
    percentage = (covered.to_f / countable_lines * 100).round(2)
    puts "  #{short_name}: #{covered}/#{countable_lines} lines (#{percentage}%)"
  end

  overall_percentage = total_lines.positive? ? (covered_lines.to_f / total_lines * 100).round(2) : 0
  puts "  TOTAL: #{covered_lines}/#{total_lines} lines (#{overall_percentage}%) across #{files} files"
  puts
end

# Compare files between sections
unit_files = data["Unit Tests"]["coverage"].keys.sort
minitest_files = data["Minitest"]["coverage"].keys.sort

puts "Files in Unit Tests but not in Minitest:"
(unit_files - minitest_files).each { |f| puts "  #{f.split('/').last(3).join('/')}" }

puts
puts "Files in Minitest but not in Unit Tests:"
(minitest_files - unit_files).each { |f| puts "  #{f.split('/').last(3).join('/')}" }
