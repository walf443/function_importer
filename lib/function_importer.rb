# add module a method to export function.
module FunctionExporter
  # raise this exception when method is not exist in a module.
  class NameError < ::NameError; end

  # Example:
  #   module Utils
  #     extend FunctionExporter
  #     
  #     def escape str
  #       "escaped_#{str}"
  #     end
  #   end
  #
  #   module Foo
  #     Utils.export self, :escape
  #
  #     def run
  #       p(escape('str')) #=> "escaped_str"
  #     end
  #   end
  #
  #   # you can rename method when argument is Hash.
  #   module Bar
  #     Utils.export self, :escape => :my_escape
  #
  #     def run
  #       p(my_escape('str')) #=> "escaped_str"
  #     end
  #   end
  #
  def export context, *args
    parent_mod = create_export_module(*args)
    context.module_eval do
      include parent_mod
    end
  end

  def create_export_module *args
    parent_mod = self.dup

    method_of = {};
    case args.first
    when Hash
      args.first.each do |key, val|
        method_of[key.to_s] = val
      end
    else
      args.each do |i| 
        method_of[i.to_s] = true
      end
    end

    no_need_methods = []
    parent_mod.instance_methods.each do |meth|
      unless method_of[meth.to_s]
        no_need_methods.push meth
      end
    end

    orig_mod = self
    parent_mod.module_eval do
      # renate method.
      method_of.each do |key, val|
        begin
          raise NameError, "no such method #{key} exist in #{orig_mod}" unless instance_method(key)
        rescue ::NameError => e
          raise NameError, "no such method #{key} exist in #{orig_mod}"
        end
        next if val.kind_of? TrueClass
        alias_method val, key
        undef_method key
      end
      no_need_methods.each do |meth|
        undef_method meth
      end
    end

    parent_mod
  end
end

# syntax suger for import function.
module FunctionImporter

  def import_function mod, *funcs
    include(mod.create_export_module(*funcs))
  end

  def import_module_function mod, *funcs
    extend(mod.create_export_module(*funcs))
  end

  private :import_function, :import_module_function
end
