/**
 * this Google Script is essential for service accounts authorized in third-party email clients, email fetching can slow down if the inbox is too heavy, archive all emails in a monthly basis to improve effiency.
 */
function archiveInbox() {
  var inbox = GmailApp.getInboxThreads();
  for (var i = 0; i < inbox.length; i++) {
    inbox[i].moveToArchive();
  }
  Logger.log('Successfully archived ' + inbox.length + ' threads.');
}

/**
 * Sets up a monthly trigger to run the archiveInbox function.
 */
function setupMonthlyArchiveTrigger() {
  // Delete any existing monthly triggers for this function
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'archiveInbox' && triggers[i].getEventType() === ScriptApp.EventType.CLOCK) {
      ScriptApp.deleteTrigger(triggers[i]);
    }
  }

  // Create a new monthly trigger that runs on the 1st of the month at a specific time
  ScriptApp.newTrigger('archiveInbox')
      .timeBased()
      .onMonthDay(1)
      .atHour(7)
      .nearMinute(1)
      .create();

  Logger.log('Monthly archive trigger set up to run on the 1st of the month at 7:01 AM.');
}

/**
 * Removes the monthly archive trigger (if it exists).
 */
function removeMonthlyArchiveTrigger() {
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'archiveInbox' && triggers[i].getEventType() === ScriptApp.EventType.CLOCK) {
      ScriptApp.deleteTrigger(triggers[i]);
      Logger.log('Monthly archive trigger removed.');
      return;
    }
  }
  Logger.log('No monthly archive trigger found.');
}
