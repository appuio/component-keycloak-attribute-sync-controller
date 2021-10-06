local attributeSync = import 'lib/attribute-sync.libsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.keycloak_attribute_sync_controller;

local attributeSyncObjects = function(name, conf)
  local secretName = name + '-credentials';
  [
    kube.Secret(secretName) {
      metadata+: {
        namespace: params.namespace,
      },
      data_: {
        username: conf.username,
        password: conf.password,
      },
    },
    attributeSync.AttributeSync(name) {
      metadata+: {
        namespace: params.namespace,
      },
      spec: {
        url: conf.url,
        [if std.objectHas(conf, 'loginRealm') then 'loginRealm']: conf.loginRealm,
        realm: conf.realm,
        attribute: conf.attribute,
        [if std.objectHas(conf, 'targetAnnotation') then 'targetAnnotation']: conf.targetAnnotation,
        [if std.objectHas(conf, 'targetLabel') then 'targetLabel']: conf.targetLabel,
        [if std.objectHas(conf, 'schedule') then 'schedule']: conf.schedule,
        credentialsSecret: {
          name: secretName,
        },
      },
    },
  ];

std.mapWithKey(attributeSyncObjects, params.sync_configurations)
