
function makeSortable (report) {
   var el = $(report).find("ul.appColumns")[0];

   if (el) {
      new Sortable(el, {
          multiDrag: true,   // Enable multi-drag
          selectedClass: 'selected', // The class applied to the selected items
          filter: '.disabled', // 'disabled' class is not draggable
          ghostClass: "sortable-ghost",
          animation: 150,

          store: {
              /**
               * Save the order of elements. Called onEnd (when the item is dropped).
               * By default Sortable will grab data-id values from the elements
               * @param {Sortable}  sortable
               */
              set: function (sortable) {                
                var order = sortable.toArray();
                updateSeq(report, order);
              }
          }

      });    
   }
}

function clearMessages() {
            // Dismiss success messages automatically
        // for APEX >19.1 change configureSuccessMessages to apex.theme42.util.configAPEXMsgs
        // in theory, after the upgrade the rest of the code below could be removed
        apex.theme42.configureSuccessMessages({
          autoDismiss: true,
          duration: 6000  // duration is optional (Default is 3000 milliseconds)
        });
    
    apex.message.clearErrors();
}

function updateSeq(pRegionID, newOrder) {
    
 if (newOrder) {
     // Start the page overlay
     setTimeout(function(){
        $wP = apex.widget.waitPopup();
      }, 1);
 }

 apex.server.process ( "UPDATE_ORDER", 
   {f01:newOrder},
   {
    success: function( pData ) 
    {
      if (pData.success) {
          
          apex.message.showPageSuccess("OCD level unlocked, table reordered.");
          clearMessages();
      }
      else {
            clearMessages();
            apex.message.showErrors({
                type:       "error",
                location:   "page",
                message:    pData.message,
                unsafe:     false
            });
          
      }
      $s("P1_CODE", pData.sql);
      apex.event.trigger(pRegionID, 'apexrefresh');

    }
   }
 ).always( function() {
    // code that needs to run for both success and failure cases
    // remove overlay and indicator
    $wP.remove();
 } );
 
}
