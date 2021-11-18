# Bootjack

[Bootjack](http://rikulo.org) is a porting of [Twitter Bootstrap](http://getbootstrap.com/) 3.0.x in Dart.

* [Home](http://rikulo.org)
* [Tutorial](http://blog.rikulo.org/posts/2013/May/General/bootjack-and-dquery/)
* [API Reference](https://pub.dev/documentation/bootjack/latest/)
* [Git Repository](https://github.com/rikulo/bootjack)
* [Discussion](http://stackoverflow.com/questions/tagged/rikulo)
* [Issues](https://github.com/rikulo/bootjack/issues)

## Install from Dart Pub Repository

Include the following in your `pubspec.yaml`:

    dependencies:
      bootjack: any

Then run the [Pub Package Manager](http://pub.dartlang.org/doc) in Dart Editor (Tool > Pub Install). If you are using a different editor, run the command
(comes with the Dart SDK):

    pub install

## Usage

First of all in your HTML file, you need to include the CSS resource:
  
	<head>
		...
		<link rel="stylesheet" href="packages/bootjack/css/bootstrap.min.css">
	</head>

Most of the functions in Bootjack components are automatic -- you only need to give the right CSS class on DOM elements and call a global function to register.

For example, a Dropdown button component is prepared by giving the following HTML snippet:

	<button class="btn btn-default dropdown-toggle" data-toggle="dropdown">
		Button
		<span class="caret"></span>
	</button>
	<ul class="dropdown-menu">
		<li><a href="#">Menu Item #1</a></li>
		<li><a href="#">Menu Item #2</a></li>
		<li><a href="#">Menu Item #3</a></li>
	</ul>

With the following global registration in Dart:

	void main() {
		Dropdown.use();
	}

That's right. All you need to do in Dart is to tell Bootjack you are using Dropdown components. You can also progammatically access and manipulate the Dropdown:

	Dropdown dd = Dropdown.wire(element);
	dd.toggle();

Check more [examples](https://github.com/rikulo/bootjack/tree/master/example) and the [API reference](http://api.rikulo.org/bootjack/latest/bootjack.html) for more features. Also, you can read the reference of [Bootstrap](http://getbootstrap.com/getting-started/).

## Notes to Contributors

### Test and Debug

You are welcome to submit [bugs and feature requests](https://github.com/rikulo/bootjack/issues). Or even better if you can fix or implement them!

### Fork Bootjack

If you'd like to contribute back to the core, you can [fork this repository](https://help.github.com/articles/fork-a-repo) and send us a pull request, when it is ready.

Please be aware that one of Rikulo's design goals is to keep the sphere of API as neat and consistency as possible. Strong enhancement always demands greater consensus.

If you are new to Git or GitHub, please read [this guide](https://help.github.com/) first.

## Who Uses

* [Quire](https://quire.io) - a simple, collaborative, multi-level task management tool.
* [Keikai](https://keikai.io) - a sophisticated spreadsheet for big data
