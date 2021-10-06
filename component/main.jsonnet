// main template for keycloak-attribute-sync-controller
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
// The hiera parameters for the component
local params = inv.parameters.keycloak_attribute_sync_controller;

local prefix = 'keycloak-attribute-sync-';

local role = std.parseJson(kap.yaml_load('keycloak-attribute-sync-controller/manifests/controller/' + params.manifest_version + '/role.yaml'));
local service_account = std.parseJson(kap.yaml_load('keycloak-attribute-sync-controller/manifests/controller/' + params.manifest_version + '/service_account.yaml'));
local role_binding = std.parseJson(kap.yaml_load('keycloak-attribute-sync-controller/manifests/controller/' + params.manifest_version + '/role_binding.yaml'));
local deployment = std.parseJson(kap.yaml_load('keycloak-attribute-sync-controller/manifests/controller/' + params.manifest_version + '/deployment.yaml'));

local image = '%(registry)s/%(repository)s:%(tag)s' % params.images.controller;

local objects = [
  role {
    metadata+: {
      name: prefix + super.name,
    },
  },
  role_binding {
    metadata+: {
      name: prefix + super.name,
    },
    roleRef+: {
      name: prefix + super.name,
    },
    subjects: std.map(function(s) s {
      name: prefix + super.name,
      namespace: params.namespace,
    }, super.subjects),
  },
  service_account {
    metadata+: {
      name: prefix + super.name,
    },
  },
  deployment {
    metadata+: {
      name: prefix + super.name,
    },
    spec+: {
      template+: {
        spec+: {
          serviceAccountName: prefix + super.serviceAccountName,
          containers: [
            if c.name == 'manager' then
              c {
                image: image,
                args: [],
              }
            else
              c
            for c in super.containers
          ],
        },
      },
    },
  },
];

{
  '10_namespace': kube.Namespace(params.namespace),
}
+
{
  ['20_' + std.asciiLower(obj.kind)]: obj {
    metadata+: {
      namespace: params.namespace,
    },
  }
  for obj in objects
}
