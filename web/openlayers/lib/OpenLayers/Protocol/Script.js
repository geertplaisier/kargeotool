/* Copyright (c) 2006-2012 by OpenLayers Contributors (see authors.txt for 
 * full list of contributors). Published under the 2-clause BSD license.
 * See license.txt in the OpenLayers distribution or repository for the
 * full text of the license. */

/**
 * @requires OpenLayers/Protocol.js
 * @requires OpenLayers/Feature/Vector.js
 * @requires OpenLayers/Format/GeoJSON.js
 */

/**
 * if application uses the query string, for example, for BBOX parameters,
 * OpenLayers/Format/QueryStringFilter.js should be included in the build config file
 */

/**
 * Class: OpenLayers.Protocol.Script
 * A basic Script protocol for vector layers.  Create a new instance with the
 *     <OpenLayers.Protocol.Script> constructor.  A script protocol is used to
 *     get around the same origin policy.  It works with services that return
 *     JSONP - that is, JSON wrapped in a client-specified callback.  The
 *     protocol handles fetching and parsing of feature data and sends parsed
 *     features to the <callback> configured with the protocol.  The protocol
 *     expects features serialized as GeoJSON by default, but can be configured
 *     to work with other formats by setting the <format> property.
 *
 * Inherits from:
 *  - <OpenLayers.Protocol>
 */
OpenLayers.Protocol.Script = OpenLayers.Class(OpenLayers.Protocol, {

    /**
     * APIProperty: url
     * {String} Service URL.  The service is expected to return serialized 
     *     features wrapped in a named callback (where the callback name is
     *     generated by this protocol).
     *     Read-only, set through the options passed to the constructor.
     */
    url: null,

    /**
     * APIProperty: params
     * {Object} Query string parameters to be appended to the URL.
     *     Read-only, set through the options passed to the constructor.
     *     Example: {maxFeatures: 50}
     */
    params: null,
    
    /**
     * APIProperty: callback
     * {Object} Function to be called when the <read> operation completes.
     */
    callback: null,

    /**
     * APIProperty: callbackTemplate
     * {String} Template for creating a unique callback function name
     * for the registry. Should include ${id}.  The ${id} variable will be
     * replaced with a string identifier prefixed with a "c" (e.g. c1, c2).
     * Default is "OpenLayers.Protocol.Script.registry.${id}".
     */
    callbackTemplate: "OpenLayers.Protocol.Script.registry.${id}",

    /**
     * APIProperty: callbackKey
     * {String} The name of the query string parameter that the service 
     *     recognizes as the callback identifier.  Default is "callback".
     *     This key is used to generate the URL for the script.  For example
     *     setting <callbackKey> to "myCallback" would result in a URL like 
     *     http://example.com/?myCallback=...
     */
    callbackKey: "callback",

    /**
     * APIProperty: callbackPrefix
     * {String} Where a service requires that the callback query string 
     *     parameter value is prefixed by some string, this value may be set.
     *     For example, setting <callbackPrefix> to "foo:" would result in a
     *     URL like http://example.com/?callback=foo:...  Default is "".
     */
    callbackPrefix: "",

    /**
     * APIProperty: scope
     * {Object} Optional ``this`` object for the callback. Read-only, set 
     *     through the options passed to the constructor.
     */
    scope: null,

    /**
     * APIProperty: format
     * {<OpenLayers.Format>} Format for parsing features.  Default is an 
     *     <OpenLayers.Format.GeoJSON> format.  If an alternative is provided,
     *     the format's read method must take an object and return an array
     *     of features.
     */
    format: null,

    /**
     * Property: pendingRequests
     * {Object} References all pending requests.  Property names are script 
     *     identifiers and property values are script elements.
     */
    pendingRequests: null,

    /**
     * APIProperty: srsInBBOX
     * {Boolean} Include the SRS identifier in BBOX query string parameter.
     *     Setting this property has no effect if a custom filterToParams method
     *     is provided.   Default is false.  If true and the layer has a 
     *     projection object set, any BBOX filter will be serialized with a 
     *     fifth item identifying the projection.  
     *     E.g. bbox=-1000,-1000,1000,1000,EPSG:900913
     */
    srsInBBOX: false,

    /**
     * Constructor: OpenLayers.Protocol.Script
     * A class for giving layers generic Script protocol.
     *
     * Parameters:
     * options - {Object} Optional object whose properties will be set on the
     *     instance.
     *
     * Valid options include:
     * url - {String}
     * params - {Object}
     * callback - {Function}
     * scope - {Object}
     */
    initialize: function(options) {
        options = options || {};
        this.params = {};
        this.pendingRequests = {};
        OpenLayers.Protocol.prototype.initialize.apply(this, arguments);
        if (!this.format) {
            this.format = new OpenLayers.Format.GeoJSON();
        }

        if (!this.filterToParams && OpenLayers.Format.QueryStringFilter) {
            var format = new OpenLayers.Format.QueryStringFilter({
                srsInBBOX: this.srsInBBOX
            });
            this.filterToParams = function(filter, params) {
                return format.write(filter, params);
            };
        }
    },
    
    /**
     * APIMethod: read
     * Construct a request for reading new features.
     *
     * Parameters:
     * options - {Object} Optional object for configuring the request.
     *     This object is modified and should not be reused.
     *
     * Valid options:
     * url - {String} Url for the request.
     * params - {Object} Parameters to get serialized as a query string.
     * filter - {<OpenLayers.Filter>} Filter to get serialized as a
     *     query string.
     *
     * Returns:
     * {<OpenLayers.Protocol.Response>} A response object, whose "priv" property
     *     references the injected script.  This object is also passed to the
     *     callback function when the request completes, its "features" property
     *     is then populated with the features received from the server.
     */
    read: function(options) {
        OpenLayers.Protocol.prototype.read.apply(this, arguments);
        options = OpenLayers.Util.applyDefaults(options, this.options);
        options.params = OpenLayers.Util.applyDefaults(
            options.params, this.options.params
        );
        if (options.filter && this.filterToParams) {
            options.params = this.filterToParams(
                options.filter, options.params
            );
        }
        var response = new OpenLayers.Protocol.Response({requestType: "read"});
        var request = this.createRequest(
            options.url, 
            options.params, 
            OpenLayers.Function.bind(function(data) {
                response.data = data;
                this.handleRead(response, options);
            }, this)
        );
        response.priv = request;
        return response;
    },

    /** 
     * APIMethod: filterToParams 
     * Optional method to translate an <OpenLayers.Filter> object into an object 
     *     that can be serialized as request query string provided.  If a custom 
     *     method is not provided, any filter will not be serialized. 
     * 
     * Parameters: 
     * filter - {<OpenLayers.Filter>} filter to convert. 
     * params - {Object} The parameters object. 
     * 
     * Returns: 
     * {Object} The resulting parameters object. 
     */

    /** 
     * Method: createRequest
     * Issues a request for features by creating injecting a script in the 
     *     document head.
     *
     * Parameters:
     * url - {String} Service URL.
     * params - {Object} Query string parameters.
     * callback - {Function} Callback to be called with resulting data.
     *
     * Returns:
     * {HTMLScriptElement} The script pending execution.
     */
    createRequest: function(url, params, callback) {
        var id = OpenLayers.Protocol.Script.register(callback);
        var name = OpenLayers.String.format(this.callbackTemplate, {id: id});
        params = OpenLayers.Util.extend({}, params);
        params[this.callbackKey] = this.callbackPrefix + name;
        url = OpenLayers.Util.urlAppend(
            url, OpenLayers.Util.getParameterString(params)
        );
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = url;
        script.id = "OpenLayers_Protocol_Script_" + id;
        this.pendingRequests[script.id] = script;
        var head = document.getElementsByTagName("head")[0];
        head.appendChild(script);
        return script;
    },
    
    /** 
     * Method: destroyRequest
     * Remove a script node associated with a response from the document.  Also
     *     unregisters the callback and removes the script from the 
     *     <pendingRequests> object.
     *
     * Parameters:
     * script - {HTMLScriptElement}
     */
    destroyRequest: function(script) {
        OpenLayers.Protocol.Script.unregister(script.id.split("_").pop());
        delete this.pendingRequests[script.id];
        if (script.parentNode) {
            script.parentNode.removeChild(script);
        }
    },

    /**
     * Method: handleRead
     * Individual callbacks are created for read, create and update, should
     *     a subclass need to override each one separately.
     *
     * Parameters:
     * response - {<OpenLayers.Protocol.Response>} The response object to pass to
     *     the user callback.
     * options - {Object} The user options passed to the read call.
     */
    handleRead: function(response, options) {
        this.handleResponse(response, options);
    },

    /**
     * Method: handleResponse
     * Called by CRUD specific handlers.
     *
     * Parameters:
     * response - {<OpenLayers.Protocol.Response>} The response object to pass to
     *     any user callback.
     * options - {Object} The user options passed to the create, read, update,
     *     or delete call.
     */
    handleResponse: function(response, options) {
        if (options.callback) {
            if (response.data) {
                response.features = this.parseFeatures(response.data);
                response.code = OpenLayers.Protocol.Response.SUCCESS;
            } else {
                response.code = OpenLayers.Protocol.Response.FAILURE;
            }
            this.destroyRequest(response.priv);
            options.callback.call(options.scope, response);
        }
    },

    /**
     * Method: parseFeatures
     * Read Script response body and return features.
     *
     * Parameters:
     * data - {Object} The data sent to the callback function by the server.
     *
     * Returns:
     * {Array({<OpenLayers.Feature.Vector>})} or
     *     {<OpenLayers.Feature.Vector>} Array of features or a single feature.
     */
    parseFeatures: function(data) {
        return this.format.read(data);
    },

    /**
     * APIMethod: abort
     * Abort an ongoing request.  If no response is provided, all pending 
     *     requests will be aborted.
     *
     * Parameters:
     * response - {<OpenLayers.Protocol.Response>} The response object returned
     *     from a <read> request.
     */
    abort: function(response) {
        if (response) {
            this.destroyRequest(response.priv);
        } else {
            for (var key in this.pendingRequests) {
                this.destroyRequest(this.pendingRequests[key]);
            }
        }
    },
    
    /**
     * APIMethod: destroy
     * Clean up the protocol.
     */
    destroy: function() {
        this.abort();
        delete this.params;
        delete this.format;
        OpenLayers.Protocol.prototype.destroy.apply(this);
    },

    CLASS_NAME: "OpenLayers.Protocol.Script" 
});

(function() {
    var o = OpenLayers.Protocol.Script;
    var counter = 0;
    o.registry = {};
    
    /**
     * Function: OpenLayers.Protocol.Script.register
     * Register a callback for a newly created script.
     *
     * Parameters:
     * callback - {Function} The callback to be executed when the newly added
     *     script loads.  This callback will be called with a single argument
     *     that is the JSON returned by the service.
     *
     * Returns:
     * {Number} An identifier for retrieving the registered callback.
     */
    o.register = function(callback) {
        var id = "c"+(++counter);
        o.registry[id] = function() {
            callback.apply(this, arguments);
        };
        return id;
    };
    
    /**
     * Function: OpenLayers.Protocol.Script.unregister
     * Unregister a callback previously registered with the register function.
     *
     * Parameters:
     * id - {Number} The identifer returned by the register function.
     */
    o.unregister = function(id) {
        delete o.registry[id];
    };
})();
