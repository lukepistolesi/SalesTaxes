Feature: No taxable items

  As a user with a list of not taxable items in the shopping basket
  I want to see the total I have to pay
  so that I can manage my spending

  Scenario: Only not taxable items in the basket
    Given the following classification keywords are set
      | Keywords          | Category |
      | chocolate, pasta  | Food     |
      | book, pinocchio   | Books    |
      | ointment, aspirin | Medical  |
    When I run the app with the following items
      | Quantity | Product Name  | Total Cost |
      | 1        | Book          | 12.49      |
      | 2        | Aspirin       | 2.76       |
      | 1        | Chocolate Bar | 0.85       |
    Then I should see a receipt with total "16.10", taxes "0.00" and items
      | Quantity | Product Name  | Price |
      | 1        | Book          | 12.49 |
      | 2        | Aspirin       | 2.76  |
      | 1        | Chocolate Bar | 0.85  |
