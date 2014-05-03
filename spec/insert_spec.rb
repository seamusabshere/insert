require 'spec_helper'

describe Insert do
  let(:connection) { PG.connect dbname: 'test_insert' }
  let(:insert)     { Insert.new connection }

  before do
    Dog.delete_all
  end

  it "inserts a row" do
    expect do
      insert.insert :dogs, age: 7
    end.to change{Dog.count}
  end

  it "inserts more than one column" do
    expect do
      insert.insert :dogs, age: 7, name: 'jerry'
    end.to change{Dog.where(age: 7, name: 'jerry').count}
  end

  it "works twice for same cols" do
    expect do
      insert.insert :dogs, age: 7, name: 'jerry'
      insert.insert :dogs, age: 2, name: 'bill'
    end.to change{Dog.where(age: 2, name: 'bill').count}
  end
end
