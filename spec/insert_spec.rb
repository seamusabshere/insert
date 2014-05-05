require 'spec_helper'

describe Insert do
  def new_connection
    PG.connect dbname: 'test_insert'
  end

  let(:connection) { new_connection }
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

  describe 'possible collisions' do
    it "doesn't blow up if used on diff connections" do
      a = Insert.new new_connection
      b = Insert.new new_connection
      expect do
        a.insert :dogs, age: 7
        b.insert :dogs, age: 7
      end.to change{Dog.count}.by(2)
    end

    it "doesn't blow up when threading" do
      a = Insert.new new_connection
      b = Insert.new new_connection
      expect do
        a.insert :dogs, age: 7
        Thread.new do
          b.insert :dogs, age: 7
        end
        sleep 2
      end.to change{Dog.count}.by(2)
    end

    it "doesn't blow up on the same connection" do
      same_connection = new_connection
      a = Insert.new same_connection
      b = Insert.new same_connection
      expect do
        a.insert :dogs, age: 7
        b.insert :dogs, age: 7
      end.to change{Dog.count}.by(2)
    end

    it "automatically re-uses prepared statements on the same connection" do
      expect do
        Insert.new(connection).insert :dogs, age: 7
        Insert.new(connection).insert :dogs, age: 7
      end.not_to raise_error
    end
  end

end
