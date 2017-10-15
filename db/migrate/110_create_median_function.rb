class CreateMedianFunction < ActiveRecord::Migration[5.0]
  def up
    ActiveMedian.create_function
  end

  def down
    ActiveMedian.drop_function
  end
end
