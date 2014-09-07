Feature: Given examples are respected

  As a developer with a list preset examples
  I want to see the output matching the given examples
  so that I know that the program is respecting the given examples

  Scenario: Example 1
    Given the following classification keywords are set
      | Keywords  | Category |
      | chocolate | Food     |
      | book      | Books    |
    When I run the app with the following items
      | Quantity | Product Name  | Total Cost |
      | 1        | book          | 12.49      |
      | 1        | music cd      | 14.99      |
      | 1        | chocolate bar | 0.85       |
    Then I should see a receipt with total "29.83", taxes "1.50" and items
      | Quantity | Product Name  | Price |
      | 1        | book          | 12.49 |
      | 1        | music cd      | 16.49 |
      | 1        | chocolate bar | 0.85  |

  Scenario: Example 2
    Given the following classification keywords are set
      | Keywords   | Category |
      | chocolates | Food     |
      | imported   | Imported |
    When I run the app with the following items
      | Quantity | Product Name               | Total Cost |
      | 1        | Imported box of chocolates | 10.00      |
      | 1        | Imported bottle of perfume | 47.50      |
    Then I should see a receipt with total "65.15", taxes "7.65" and items
      | Quantity | Product Name               | Price |
      | 1        | Imported box of chocolates | 10.50 |
      | 1        | Imported bottle of perfume | 54.65 |

  Scenario: Only imported items in the basket
    Given the following classification keywords are set
      | Keywords   | Category |
      | chocolates | Food     |
      | headache   | Medical  |
      | imported   | Imported |
    When I run the app with the following items
      | Quantity | Product Name               | Total Cost |
      | 1        | Imported bottle of perfume | 27.99      |
      | 1        | Bottle of perfume          | 18.99      |
      | 1        | Packet of headache pills   | 9.75       |
      | 1        | box of imported chocolates | 11.25      |
    Then I should see a receipt with total "74.68", taxes "6.70" and items
      | Quantity | Product Name               | Price |
      | 1        | Imported bottle of perfume | 32.19 |
      | 1        | Bottle of perfume          | 20.89 |
      | 1        | Packet of headache pills   | 9.75  |
      | 1        | box of imported chocolates | 11.85 |

