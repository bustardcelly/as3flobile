# About

The as3flobile project generates library SWCs into two output bins:

## standalone

The standalone bin contains the library SWC that can be added to the library
of a project without the need of having the dependant [as3signals](http://github.com/robertpenner/as3-signals) library. 
The standalone [as3flobile swc](http://github.com/bustardcelly/as3flobile/tree/master/bin/standalone/), compiles in the dependent classes from the as3signals standalone library. 
As such, the file size for the standalone SWC is higher than the external library, as it has dependencies compiled in. 
If you are not worried about file size and/or you do not want to manage dependencies in your project library, 
use the standalone SWC or SWF.

## external

The external bin contains the library SWC that is compiled against dependent SWC libraries:
[as3signals](http://github.com/robertpenner/as3-signals). Included in the external SWC are only the source files 
from the as3flobile library. As such, the file size for the external SWC is lower than the standalone
yet it is necessary to include the dependent libraries (as3signals) within your project. If you are worried about
file size and/or are fine with managing library dependencies, use the external SWC or SWF.

# Dependencies

The as3flobile library depends on the following libraries in order to compile:

## as3signals

The as3flobile library is built against the [as3signals library](http://github.com/robertpenner/as3-signals). as3flobile uses Signals from as3signals in replacement of events and interface delegates.
Read more about [as3signals](http://github.com/robertpenner/as3-signals/wiki). 