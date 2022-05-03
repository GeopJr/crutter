<h1 align="center">crutter</h1>
<h4 align="center">Create Flutter Widgets from Crystal.</h4>
<p align="center">
  <br />
    <a href="https://github.com/GeopJr/crutter/blob/main/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Contributor%20Covenant-v2.1-08589c.svg?style=for-the-badge&labelColor=44d1fd" alt="Code Of Conduct" /></a>
    <a href="https://github.com/GeopJr/crutter/blob/main/LICENSE"><img src="https://img.shields.io/badge/LICENSE-BSD--2--Clause-08589c.svg?style=for-the-badge&labelColor=44d1fd" alt="BSD-2-Clause" /></a>
    <a href="https://github.com/GeopJr/crutter/actions"><img src="https://img.shields.io/github/workflow/status/geopjr/crutter/Specs%20&%20Lint/main?labelColor=44d1fd&style=for-the-badge" alt="ci action status" /></a>
</p>

## What is crutter?

As of now crutter is a POC.

Crystal 1.4.0 introduced compiling to WASM. Dart has *minimal* support for consuming WASM right now.

crutter generates widgets in JSON format that are to be consumed by [json_dynamic_widget](https://github.com/peiffer-innovations/json_dynamic_widget), a Dart package that creates widgets dynamically from JSON.

json_dynamic_widget has a lot of features like functions that exapand in Dart.

See [`./spec/`](./spec/).

## Why is it a POC?

Dart's WASM support is *very* alpha. It uses wasmer and it's messy between platforms and SDK versions.

Even after getting over those, it doesn't support all Crystal WASM functions (and honestly I'm unsure if it ever will).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     crutter:
       github: GeopJr/crutter
   ```

2. Run `shards install`

## Usage

You can find crutter's docs on the sidebar.

The following code is just a concept, it's untested and depends on assumptions.

WASM:

```crystal
require "crutter"

def create_text(title : String)
  center = Crutter::Widget.new("center")
  text = Crutter::Widget.new("text")

  text.args["text"] = title
  center.children << text

  center.to_json #=> {"type":"center","child":{"type":"text","args":{"text":"#{title}"}}}
end
```

Dart:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_wasm/flutter_wasm.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ByteData bytes = await rootBundle.load('crystal/main-final.wasm');
  final data = bytes.buffer.asUint8List();
  final mod = WasmModule(data);
  final inst = mod.builder().build();
  final create_text = inst.lookupFunction('create_text');

  final text_widget = create_text("hello world")
  final json_data = json.decode(text_widget);

  final json_widget_data = JsonWidgetData.fromDynamic(
        json_data
  );
}
```

> Unsure whether the above even compiles but gets the point across:

> Dart --create_text("hello world")--> Crystal (WASM) --widget--> Dart

## Contributing

1. Read the [Code of Conduct](https://github.com/GeopJr/crutter/blob/main/CODE_OF_CONDUCT.md)
2. Fork it (<https://github.com/GeopJr/crutter/fork>)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
