require 'digest'
require 'pp'

class Block
  attr_reader :previous_hash, :data, :index, :time, :current_hash

  def initialize(previous_hash, data, index = 0)
    @previous_hash = previous_hash
    @data          = data
    @index         = index
    @time          = Time.now.utc
    @current_hash  = current_hash
  end

  def self.run
    last_block = Block.genesis
    last_index = last_block.index
    while true do
      next_block = Block.next(last_block, 'transaction data', last_index + 1)
      last_block, last_index = [next_block, next_block.index]
      pp next_block
      sleep 5
    end
  end

  def self.genesis(data = 'a new beginning')
    Block.new('0', data)
  end

  def self.next(previous_block, data = '', index)
    Block.new(previous_block.current_hash, data, index)
  end

  def current_hash
    sha256 = Digest::SHA256.new
    sha256.update(@index.to_s + @time.to_s + @previous_hash + @data)
    sha256.hexdigest
  end
end
pp Block.run