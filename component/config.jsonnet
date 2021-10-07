local common = import 'common.libsonnet';
local attributeSync = import 'lib/attribute-sync.libsonnet';
local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.keycloak_attribute_sync_controller;

local secrets = [
  if params.sync_credentials[s] != null then
    kube.Secret(s) {
      metadata+: {
        namespace: params.namespace,
        labels+: common.CommonLabels,
      },
    } + com.makeMergeable(params.sync_credentials[s])
  for s in std.objectFields(params.sync_credentials)
];

local attributeSyncObjs = [
  if params.sync_configurations[o] != null then
    attributeSync.AttributeSync(o) {
      metadata+: {
        namespace: params.namespace,
        labels+: common.CommonLabels,
      },
      spec: params.sync_configurations[o],
    }
  for o in std.objectFields(params.sync_configurations)
];

{
  sync_credentials: std.filter(
    function(it) it != null,
    secrets,
  ),
  sync_configurations: std.filter(
    function(it) it != null,
    attributeSyncObjs,
  ),
}
