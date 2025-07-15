(function() {
  "use strict";
  App.SUAManagementRelationSearch = {
    initialize: function() {
      App.SUASyncGoalAndTargetFilters.sync($(".sua-relations-search"));
    }
  };
}).call(this);
