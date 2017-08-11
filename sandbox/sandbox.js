(function() {
  var MockAPI, MockRequest,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MockRequest = (function() {
    function MockRequest(responseText) {
      var mockLoad;
      this._responseText = responseText;
      this._listener = null;
      mockLoad = (function(_this) {
        return function() {
          if (_this._listener) {
            return _this._listener({
              target: {
                responseText: responseText
              }
            });
          }
        };
      })(this);
      setTimeout(mockLoad, 0);
    }

    MockRequest.prototype.addEventListener = function(eventType, listener) {
      return this._listener = listener;
    };

    return MockRequest;

  })();

  MockAPI = (function(_super) {
    __extends(MockAPI, _super);

    MockAPI._autoInc = 0;

    function MockAPI(baseURL, baseParams) {
      if (baseURL == null) {
        baseURL = '/';
      }
      if (baseParams == null) {
        baseParams = {};
      }
      MockAPI.__super__.constructor.call(this, baseURL = '/', baseParams = {});
      this._snippetTypes = {
        'article-body': [
          {
            'id': 'basic',
            'label': 'Basic'
          }, {
            'id': 'advanced',
            'label': 'Advanced'
          }
        ],
        'article-related': [
          {
            'id': 'basic',
            'label': 'Basic'
          }, {
            'id': 'archive',
            'label': 'Archive'
          }
        ]
      };
      this._snippets = {
        'article-body': [
          {
            'id': this.constructor._getId(),
            'type': this._snippetTypes['article-body'][0],
            'scope': 'local',
            'settings': {}
          }, {
            'id': this.constructor._getId(),
            'type': this._snippetTypes['article-body'][1],
            'scope': 'local',
            'settings': {}
          }
        ],
        'article-related': [
          {
            'id': this.constructor._getId(),
            'type': this._snippetTypes['article-related'][1],
            'scope': 'local',
            'settings': {}
          }, {
            'id': this.constructor._getId(),
            'type': this._snippetTypes['article-related'][0],
            'scope': 'local',
            'settings': {}
          }
        ]
      };
      this._globalSnippets = {
        'article-body': [
          {
            'id': this.constructor._getId(),
            'type': this._snippetTypes['article-body'][0],
            'scope': 'global',
            'settings': {},
            'global_id': this.constructor._getId(),
            'label': 'Client logos'
          }
        ],
        'article-related': []
      };
    }

    MockAPI._getId = function() {
      this._autoInc += 1;
      return this._autoInc;
    };

    MockAPI.prototype._callEndpoint = function(method, endpoint, params) {
      var fields, globalId, globalSnippet, id, newSnippets, otherSnippet, snippet, snippetType, snippets, _i, _j, _k, _l, _len, _len1, _len2, _len3, _len4, _len5, _m, _n, _ref, _ref1, _ref2, _ref3, _ref4;
      if (params == null) {
        params = {};
      }
      switch (endpoint) {
        case 'add-snippet':
          snippetType = null;
          _ref = this._snippetTypes[params['flow']];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            snippetType = _ref[_i];
            if (snippetType.id === params['snippet_type']) {
              break;
            }
          }
          snippet = {
            'id': this.constructor._getId(),
            'type': snippetType,
            'scope': 'local',
            'settings': {}
          };
          this._snippets[params['flow']].push(snippet);
          return this._mockResponse({
            'html': "<div class=\"content-snippet\" data-cf-snippet=\"" + snippet.id + "\">\n    <p>This is a new snippet</p>\n</div>"
          });
        case 'add-global-snippet':
          globalSnippet = null;
          _ref1 = this._globalSnippets[params['flow']];
          for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
            globalSnippet = _ref1[_j];
            if (globalSnippet.global_id === params['global_snippet']) {
              break;
            }
          }
          snippet = {
            'id': this.constructor._getId(),
            'type': globalSnippet.type,
            'scope': globalSnippet.scope,
            'settings': globalSnippet.settings,
            'global_id': globalSnippet.id,
            'label': globalSnippet.label
          };
          this._snippets[params['flow']].push(snippet);
          return this._mockResponse({
            'html': "<div class=\"content-snippet\" data-cf-snippet=\"" + snippet.id + "\">\n    <p>This is a global snippet: " + snippet.label + "</p>\n</div>"
          });
        case 'delete-snippet':
          snippets = this._snippets[params['flow']];
          newSnippets = [];
          for (_k = 0, _len2 = snippets.length; _k < _len2; _k++) {
            snippet = snippets[_k];
            if (snippet.id !== params['snippet']) {
              newSnippets.push(snippet);
            }
          }
          this._snippets[params['flow']] = newSnippets;
          return this._mockResponse();
        case 'global-snippets':
          return this._mockResponse({
            'snippets': this._globalSnippets[params['flow']]
          });
        case 'order-snippets':
          snippets = {};
          _ref2 = this._snippets[params['flow']];
          for (_l = 0, _len3 = _ref2.length; _l < _len3; _l++) {
            snippet = _ref2[_l];
            snippets[snippet.id] = snippet;
          }
          newSnippets = [];
          _ref3 = params['snippets'];
          for (_m = 0, _len4 = _ref3.length; _m < _len4; _m++) {
            id = _ref3[_m];
            newSnippets.push(snippets[id]);
          }
          this._snippets[params['flow']] = newSnippets;
          return this._mockResponse();
        case 'snippets':
          return this._mockResponse({
            'snippets': this._snippets[params['flow']]
          });
        case 'snippet-scope':
          snippet = null;
          _ref4 = this._snippets[params['flow']];
          for (_n = 0, _len5 = _ref4.length; _n < _len5; _n++) {
            otherSnippet = _ref4[_n];
            if (otherSnippet.id === params['snippet']) {
              snippet = otherSnippet;
              break;
            }
          }
          if (params['scope'] === 'local') {
            snippet.scope = 'local';
            delete snippet.global_id;
            delete snippet.label;
            return this._mockResponse();
          } else {
            if (!params['label']) {
              return this._mockError({
                'label': 'This field is required'
              });
            }
            globalId = this.constructor._getId();
            this._globalSnippets[params['flow']].push({
              'id': this.constructor._getId(),
              'type': snippet.type,
              'scope': 'global',
              'settings': snippet.settigns,
              'global_id': globalId,
              'label': params['label']
            });
            snippet.scope = 'global';
            snippet.global_id = globalId;
            snippet.label = params['label'];
            return this._mockResponse();
          }
          break;
        case 'snippet-settings':
          if (method.toLowerCase() === 'get') {
            fields = [
              {
                'type': 'boolean',
                'name': 'boolean_example',
                'label': 'Boolean example',
                'required': false,
                'value': true
              }, {
                'type': 'select',
                'name': 'select_example',
                'label': 'Select example',
                'required': true,
                'value': 1,
                'choices': [[1, 'One'], [2, 'Two'], [3, 'Three']]
              }, {
                'type': 'text',
                'name': 'Text_example',
                'label': 'Text example',
                'required': true,
                'value': 'foo'
              }
            ];
            return this._mockResponse({
              'fields': fields
            });
          } else {

          }
          return this._mockResponse({
            'html': "<div class=\"content-snippet\" data-cf-snippet=\"" + params['snippet'] + "\">\n    <p>This is a snippet with updated settings</p>\n</div>"
          });
        case 'snippet-types':
          return this._mockResponse({
            'snippet_types': this._snippetTypes[params['flow']]
          });
      }
    };

    MockAPI.prototype._mockError = function(errors) {
      var response;
      response = {
        'status': 'fail'
      };
      if (errors) {
        response['errors'] = errors;
      }
      return new MockRequest(JSON.stringify(response));
    };

    MockAPI.prototype._mockResponse = function(payload) {
      var response;
      response = {
        'status': 'success'
      };
      if (payload) {
        response['payload'] = payload;
      }
      return new MockRequest(JSON.stringify(response));
    };

    return MockAPI;

  })(ContentFlow.BaseAPI);

  window.addEventListener('load', function() {
    var api, editor, flowMgr, idProp, queryOrDOMElements;
    editor = ContentTools.EditorApp.get();
    flowMgr = ContentFlow.FlowMgr.get();
    editor.init('[data-cf-snippet], [data-fixture]', 'data-cf-snippet');
    return flowMgr.init(queryOrDOMElements = '[data-cf-flow]', idProp = 'data-cf-flow', api = new MockAPI());
  });

}).call(this);
