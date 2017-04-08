module StatsHelper
  # See: http://stackoverflow.com/a/14859546/1323144
  def median(array)
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  # See: http://stackoverflow.com/a/1341318/1323144
  def mean(array)
    array.inject { |sum, el| sum + el }.to_f / array.size
  end

  def humanize secs
    [[60, :seconds], [60, :minutes], [24, :hours], [1000, :days]].map{ |count, name|
      if secs > 0
        secs, n = secs.divmod(count)
        "#{n.to_i} #{name}"
      end
    }.compact.reverse.join(' ')
  end
end
