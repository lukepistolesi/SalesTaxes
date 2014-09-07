Feature: Imported items

  As a user with a list of imported items in the shopping basket
  I want to see the import taxes that I have to pay
  so that I can manage my spending

  Scenario: Only imported items in the basket
    Given the following classification keywords are set
      | Keywords    | Category |
      | nuts, nutty | Food     |
      | imported    | Imported |
    When I run the app with the following items
      | Quantity | Product Name         | Total Cost |
      | 1        | Imported nuts        | 12.49      |
      | 2        | Imported nutty stuff | 2.76       |
    Then I should see a receipt with total "16.05", taxes "0.80" and items
      | Quantity | Product Name         | Price |
      | 1        | Imported nuts        | 13.14 |
      | 2        | Imported nutty stuff | 2.91  |
