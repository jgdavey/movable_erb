Feature: CSV Conversion
  In order to convert my list of contacts to blog format
  As a Command-line user
  I want to use commandline utility to convert CSV files to MTImport files

  Scenario: A short CSV of contacts
    Given I am on the commandline
    When I invoke the utility with the following CSV file:
      """
      Title,Body,Body
      John,773-123-1234,john@example.com
      Abigail,,abby@example.com
      Bernard,903-294-3921,
      """
    Then I should see the following output:
      """
      TITLE: John
      -----
      BODY:

      773-123-1234
      john@example.com

      --------
      TITLE: Abigail
      -----
      BODY:

      abby@example.com
      
      --------
      TITLE: Bernard
      -----
      BODY:

      903-294-3921
      
      --------
      
      """
