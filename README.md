Packer Templates
===========================
These are my packer templates I use to build Vagrant boxes

##Requirements
* [packer](http://packer.io) >= 0.7.5
* [ruby](http://ruby-lang.org) >= 1.9.3-p551
* [rake](https://github.com/ruby/rake)
* [virtualbox](http://virtualbox.org) >=  4.3
* [vagrant](http://vagrantup.com) >= 1.6

##How to build/use vagrant boxes

This project has been crafted with CI and versioning in mind from the ground up, that's the reason why using `packer` wouldn't be enough. You need to use `rake` in order to build vagrant boxes based on templates located at the `templates` directory, like so:

```bash
rake # This will build all vagrant boxes
```

However, if you want to build a single box, you can do it this way.

```bash
rake <image_name> # this will build the template located at templates/<image_name>/template.json
```

```bash
rake ubuntu-14.04-x64 # this will build the template located at templates/ubuntu-14.04-x64/template.json
```

These are the available boxes:

* `ubuntu-14.04-x86`
* `ubuntu-14.04-x64`
* `centos-7.0-x64`

Vagrant boxes will be at  the `dist` directory with its correspondent *box metadata* file

```bash
rake centos-7.0-x64
...
ls -lh dist/
-rw-rw-r-- 1 alejandro alejandro 424M Apr 13 08:40 centos-7.0-x64_0.0.227706647.box
-rw-rw-r-- 1 alejandro alejandro  281 Apr 13 09:48 centos-7.0-x64.json

```

##Test those boxes

OK, so you have welll-built your boxes with packer and now you want to test them. Turns out that you can do it out-of-the-box.

```bash
cp site.rb.sample site.rb
```

```bash
vagrant up
```

##Copyright and Licensing
Copyright (c) 2015 Alejandro Ricoveri

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
