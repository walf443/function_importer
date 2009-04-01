require File.join(File.dirname(__FILE__), 'spec_helper')

describe FunctionExporter do
  before :all do
    @module = Module.new
    @module.module_eval do
      extend FunctionExporter

      define_method :escape do |str|
        "escaped_#{str}"
      end

    end
  end

  describe 'export a function' do
    before do
      @export_mod = @module.create_export_module :escape
    end

    it 'should return Module' do
      @export_mod.should be_kind_of(Module)
    end

    it 'should have #escape as public' do
      @export_mod.public_instance_methods.any? {|i| i.to_s == 'escape' }.should be_true
    end
  end

  describe 'export a function with rename' do
    before do
      @export_mod = @module.create_export_module :escape => :my_escape
    end

    it 'should not have #escape' do
      @export_mod.instance_methods.all? {|i| i.to_s != 'escape' }.should be_true
    end

    it 'should have #my_escape as public' do
      @export_mod.instance_methods.any? {|i| i.to_s == 'my_escape' }.should be_true
    end
  end

  it 'should raise Exception when unexist method' do
    lambda {
      @module.create_export_module :no_exist_method_in_module
    }.should raise_error(FunctionExporter::NameError)
  end
end
