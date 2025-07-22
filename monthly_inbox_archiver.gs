/**
 * Archives all emails in the inbox on a monthly basis, by Juan Victoriano.
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

  // Create a new monthly trigger that runs on the 1st of the month at a specific time, below it will run on the 1st, 5:01 AM
  ScriptApp.newTrigger('archiveInbox')
      .timeBased()
      .onMonthDay(1)
      .atHour(5)
      .nearMinute(1)
      .create();

  Logger.log('Monthly archive trigger set up to run on the 1st of the month at 5:01 AM.');
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
