local CommonLabels = {
  'app.kubernetes.io/managed-by': 'commodore',
  'app.kubernetes.io/part-of': 'syn',
  'app.kubernetes.io/name': 'keycloak-attribute-sync-controller',
};

local AddCommonLabels = function(object) object {
  metadata+: {
    labels+: CommonLabels,
  },
};

{
  CommonLabels: CommonLabels,
  AddCommonLabels: AddCommonLabels,
}
