define(function (require) {
    'use strict';

    var Backbone = require('Backbone');
    var _ = require('_');
    var eventBrokerMixin = require('core/event-broker');
    var listenerMixin = require('core/listener');

    var Model = Backbone.Model.extend({

        constructor: function (attributes, options) {
            if(this.cache) {
                var id = (attributes && attributes.id) || this.id || _.result(this, 'cacheId');
                if(id) {
                  if(this.cache[id]) {
                      return this.cache[id];
                  } else {
                      this.cache[id] = this;
                  }
                }
            }

            Backbone.Model.apply(this, arguments);

            this.delegateListeners();
        },


        save: function(attributes, options) {
            this.trigger('before:save', this);
            return Backbone.Model.prototype.save.call(this, attributes, options);
        },

        unary: function (name, operation) {
            var value = this.get(name);
            this.set(name, operation(value));
        },

        toggleAttr: function (name) {
            this.unary(name, function (value) {
                return !value;
            });
        },

        inc: function (name, val) {
            if (!val) {
                val = 1;
            }

            this.unary(name, function (value) {
                return value + val;
            });
        },

        dec: function (name, val) {
            if (!val) {
                val = 1;
            }

            this.unary(name, function (value) {
                return value - val;
            });
        },

        dispose: function () {
            // todo: Закончить
            return;

            if(this.disposed) {
                return;
            }

            // Finished.
            this.disposed = true;

            // Unbind all global event handlers.
            this.unsubscribeAllEvents();

            // Unbind all referenced handlers.
            this.stopListening();

            // Remove all event handlers on this module.
            this.off();


            // Remove the collection reference, internal attribute hashes
            // and event handlers.
            var properties = [
                'collection',
                'attributes', 'changed',
                '_escapedAttributes', '_previousAttributes',
                '_silent', '_pending',
                '_callbacks'
            ];

        }

    });

    _.extend(Model.prototype, eventBrokerMixin, listenerMixin);

    return Model;
});
