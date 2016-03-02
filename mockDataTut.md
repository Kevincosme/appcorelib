# Tutorial #

The potential of Flex for rapid prototyping and general application development is amazingly fast. With some mock data and a basic user-experience (UX) scenario, a developer can create a functioning sample application in a matter of minutes.

If you are developing either a full blown RIA or a prototype application then you have probably at least heard of Cairngorm.  I use a stripped down version of it for almost every project I have worked on. It works beautifully

I plan to show you an example of using AppCoreLib’s XMLDataBroker to fill in some mock XML data for your commands. This is helpful when you have a basic idea of an API/services but they are not returning anything or not ready to be tapped or you wanna test out a service’s result format before the server developers implement it.

Before I continue, let’s set one or two rules about this tutorial.

  * the expected format for the returned data is XML
  * the mock XML data format will reflect the same format of the actual service’s result

# Details #


Firstly let’s take a look at a basic Cairngorm command. This is a stripped down version so you won’t see any delegate-type references in here.

```
package com.foo.controller.commands
{
    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;
    import com.foo.business.Services;

    import mx.rpc.AsyncToken;
    import mx.rpc.IResponder;
    import mx.rpc.events.ResultEvent;
    import mx.rpc.http.HTTPService;

    public class SampleCairngormCommand implements ICommand, IResponder
    {
        private var _vo:Object = {};

        public function execute (event:CairngormEvent):void
        {
            var call:HTTPService = Services.getInstance().httpService;
            call.url = "http://www.foo.com/someService";

            var param:Object = {};

            var token:AsyncToken = call.send(param);
            token.addResponder(this);
        }

        public function result (data:Object):void
        {
            var xmlResult:XML = ResultEvent(data).result as XML;
        }

        public function fault (info:Object):void
        {
        }

    }
}
```

So now with about 5 lines of code, I will show you how to inject mock XML data for creating a response that fits within the Cairngorm command structure:

```
package com.foo.controller.commands
{
    import appCoreLib.business.XMLDataBroker;
    import appCoreLib.events.XMLLoadEvent;

    import com.adobe.cairngorm.commands.ICommand;
    import com.adobe.cairngorm.control.CairngormEvent;

    import mx.rpc.IResponder;

    public class SampleCairngormCommand implements ICommand, IResponder
    {
        public function execute (event:CairngormEvent):void
        {
            var x:XMLDataBroker = new XMLDataBroker();
            x.addEventListener(XMLLoadEvent.XML_LOAD_SUCCESS, result);
            x.addEventListener(XMLLoadEvent.XML_LOAD_FAILURE, fault);
            x.loadXML("assets/xml/someMockXMLData.xml");

            /* var call:HTTPService = Services.getInstance().httpService;
            call.url = "http://www.foo.com/someService";

            var param:Object = {};

            var token:AsyncToken = call.send(param);
            token.addResponder(this); */
        }

        public function result (data:Object):void
        {
            var xmlResult:XML = XMLLoadEvent(data).xml;
            //var xmlResult:XML = ResultEvent(data).result as XML;
        }

        public function fault (info:Object):void
        {
        }
    }
}
```

That’s it! Simple, effective and most importantly, easy to remove once an actual service response is available.

The original posting can be read here - [link](http://jwopitz.wordpress.com/2008/05/12/tutorial-appcorelibs-xmldatabroker-mock-xml-data-cairngorm/)