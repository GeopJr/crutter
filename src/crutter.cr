require "json"

module Crutter
  class Widget
    # *type* is a Flutter Widget type (eg scaffold)
    def initialize(type : String)
      @type = type
      @args = Hash(String, Crutter::Widget | String).new
      @children = [] of Crutter::Widget
      @listen = [] of String
    end

    # Widget args
    #
    # Example:
    # ```Dart
    # Container(
    #   height: 56.0, // <- this is an arg
    #   child: ...
    # );
    # ```
    # WARNING: Above code is in Dart
    def args : Hash(String, Crutter::Widget | String)
      @args
    end

    # Widget children.
    #
    # If only one child is provided then instead of "children" (`Array(Crutter::Widget)`) it becomes "child" (`Crutter::Widget`).
    #
    # Example:
    # ```Dart
    # Container(
    #   ...
    #   child: Center(...)
    # );
    # ```
    # WARNING: Above code is in Dart
    def children : Array(Crutter::Widget)
      @children
    end

    def listen : Array(String)
      @listen
    end

    # Widget to Hash
    def to_h : Hash(String, String | Array(String) | Crutter::Widget | Nil | Array(Crutter::Widget) | Hash(String, Crutter::Widget | String))
      result = Hash(String, String | Array(String) | Crutter::Widget | Nil | Array(Crutter::Widget) | Hash(String, Crutter::Widget | String)).new
      result["type"] = @type
      result["args"] = @args unless @args.size == 0
      result["listen"] = @listen unless @listen.size == 0

      children_size = @children.size
      unless children_size == 0
        if children_size == 1
          result["child"] = @children.first?
        else
          result["children"] = @children
        end
      end

      result
    end

    # :nodoc:
    def to_json(t : JSON::Builder)
      self.to_h.to_json(t)
    end

    # Widget to JSON
    def to_json : String
      self.to_h.to_json
    end

    # Widget to pretty JSON
    def to_pretty_json : String
      self.to_h.to_pretty_json
    end
  end
end
