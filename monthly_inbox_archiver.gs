/**
 * this Google Script is essential for service accounts authorized in third-party email clients, email fetching can slow down if the inbox is too heavy, archive all emails in a monthly basis to improve effiency.
 */
function archiveInbox() {
  var batchSize = 100; // Gmail API max per call
  var start = 0;
  var threads;

  do {
    // Get next batch of inbox threads
    threads = GmailApp.getInboxThreads(start, batchSize);

    // Move them to archive
    for (var i = 0; i < threads.length; i++) {
      threads[i].moveToArchive();
    }

    start += batchSize;
  } while (threads.length === batchSize);

  Logger.log('Successfully archived all inbox threads.');
}

/**
 * Sets up a monthly trigger to run the archiveInbox function.
 * Runs on the 1st of each month at 7:01 AM.
 */
function setupMonthlyArchiveTrigger() {
  // Delete any existing monthly triggers for this function
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'archiveInbox') {
      ScriptApp.deleteTrigger(triggers[i]);
    }
  }

  // Create a new monthly trigger
  ScriptApp.newTrigger('archiveInbox')
    .timeBased()
    .onMonthDay(1)
    .atHour(7)
    .nearMinute(1)
    .create();

  Logger.log('Monthly archive trigger set up for the 1st at 7:01 AM.');
}

/**
 * Removes the monthly archive trigger (if it exists).
 */
function removeMonthlyArchiveTrigger() {
  var triggers = ScriptApp.getProjectTriggers();
  for (var i = 0; i < triggers.length; i++) {
    if (triggers[i].getHandlerFunction() === 'archiveInbox') {
      ScriptApp.deleteTrigger(triggers[i]);
      Logger.log('Monthly archive trigger removed.');
      return;
    }
  }
  Logger.log('No monthly archive trigger found.');
}
