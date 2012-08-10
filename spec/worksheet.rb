require 'csv'

class WorksheetStub
  def self.from_CSV(fullpath)
    self.new(CSV.read fullpath)
  end
  def initialize(array)
    @cells = array
  end

  def [](*tuple)
    (row, col) = tuple
    @cells[row - 1][col - 1] || nil
  end

  def []=(*args)
    (row, col) = args[0...-1]
    @cells[row - 1][col - 1] = args[-1].to_s
  end
end