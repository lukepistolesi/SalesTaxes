Feature: GST only taxable items

  As a user with a list of taxable items in the shopping basket
  I want to see how much money I have to pay as GST
  so that I can manage my spending

  Scenario: Only GST eligible items in the basket
    Given no keywords for items classification are set
    When I run the app with the following items
      | Quantity | Product Name  | Total Cost |
      | 1        | Book          | 12.49      |
      | 1        | Chocolate Bar | 0.85       |
    Then I should see a receipt with total "14.69", taxes "1.35" and items
      | Quantity | Product Name  | Price |
      | 1        | Book          | 13.74 |
      | 1        | Chocolate Bar | 0.95  |
