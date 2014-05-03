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

  it "blows up without deallocate" do
    expect do
      Insert.new(connection).insert :dogs, age: 7
      Insert.new(connection).insert :dogs, age: 7
    end.to raise_error(PG::DuplicatePstatement)
  end

  it "can deallocate" do
    a = Insert.new(connection)
    b = Insert.new(connection)
    expect do
      a.insert :dogs, age: 7
      a.deallocate
      b.insert :dogs, age: 7
    end.to change{Dog.count}.by(2)
  end

  it "won't allow insert after deallocate" do
    insert.deallocate
    expect{insert.insert(:dogs, age: 7)}.to raise_error(/can't.*dealloc/i)
  end

  it "won't allow deallocate after deallocate" do
    insert.deallocate
    expect{insert.deallocate}.to raise_error(/can't.*dealloc/i)
  end

end
