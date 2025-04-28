(function() {
  "use strict";
  App.SUARelatedListSelector = {
    initialize: function() {
      if ($(".sua-related-list-selector").length) {
        var amsify_suggestags = new AmsifySuggestags($(".sua-related-list-selector .input"));

        amsify_suggestags.getItem = function(value) {
          var item_key = this.getItemKey(value);
          return this.settings.suggestions[item_key];
        };

        amsify_suggestags.getTag = function(value) {
          if (this.getItem(value) !== undefined) {
            return $("<div>" + this.getItem(value).display_text + "</div>").text();
          } else {
            return value;
          }
        };

        amsify_suggestags.setIcon = function() {
          var remove_tag_text = $(".sua-related-list-selector .input").data("remove-tag-text");
          return '<button aria-label="' + remove_tag_text + '" class="remove-tag ' + this.classes.removeTag.substring(1) + '">&#10006;</button>';
        };

        amsify_suggestags._settings({
          suggestions: $(".sua-related-list-selector .input").data("suggestions-list"),
          whiteList: true,
          afterRemove: function(value) {
            var keep_goal = $(amsify_suggestags.selector).val().split(",").some(function(selected_value) {
              return App.SUARelatedListSelector.goal_code(value) === App.SUARelatedListSelector.goal_code(selected_value);
            });
            App.SUARelatedListSelector.goal_element(value).prop("checked", keep_goal);
            App.SUARelatedListSelector.manage_remove_help(amsify_suggestags, value);
          },
          afterAdd: function(value) {
            App.SUARelatedListSelector.goal_element(value).prop("checked", true);
            App.SUARelatedListSelector.manage_add_help(amsify_suggestags, value);
          },
          keepLastOnHoverTag: false,
          checkSimilar: false
        });
        amsify_suggestags.classes.focus = ".sua-related-list-focus";
        amsify_suggestags.classes.sTagsInput = ".sua-related-list-selector-input";
        amsify_suggestags._init();
        App.SUARelatedListSelector.manage_icons(amsify_suggestags);
        App.SUARelatedListSelector.fix_label(amsify_suggestags);
      }
    },
    manage_icons: function(amsify_suggestags) {
      $(".sua-related-list-selector .goals input").on("change", function() {
        var goal_id = this.dataset.code;

        if (amsify_suggestags.isPresent(goal_id)) {
          amsify_suggestags.removeTag(goal_id, false);
        } else {
          amsify_suggestags.addTag(goal_id, false);
        }
      }).on("keydown", function(event) {
        if (event.keyCode === 13) {
          $(this).trigger("click");
          event.preventDefault();
          event.stopPropagation();
        }
      });
    },
    goal_element: function(value) {
      return $(".sua-related-list-selector .goals [data-code=" + App.SUARelatedListSelector.goal_code(value) + "]");
    },
    goal_code: function(value) {
      return value.toString().split(".")[0];
    },
    manage_add_help: function(amsify_suggestags, value) {
      var title = amsify_suggestags.getItem(value).title;
      var html = '<li data-id="' + value + '">' + "<strong>" + value + "</strong> " + title + "</li>";
      $(".sua-related-list-selector .help-section").removeClass("hide");
      $(".sua-related-list-selector .selected-info").append(html);
    },
    manage_remove_help: function(amsify_suggestags, value) {
      $('[data-id="' + value + '"]').remove();
      if ($(amsify_suggestags.selector).val() === "") {
        $(".sua-related-list-selector .help-section").addClass("hide");
      }
    },
    fix_label: function(amsify_suggestags) {
      var original_input = amsify_suggestags.selector;
      var suggestions_input = amsify_suggestags.selectors.sTagsInput;

      suggestions_input[0].id = original_input[0].id + "_suggestions";

      $("[for='" + original_input[0].id + "']").attr("for", suggestions_input[0].id);
    }
  };
}).call(this);
