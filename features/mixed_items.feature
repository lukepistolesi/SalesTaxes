Feature: Mixed items

  As a user with a list of mixed items in the shopping basket
  I want to see the amount of taxes and the total price I have to pay
  so that I can understand the cost of the goods

  Scenario: Only imported items in the basket
    Given the following classification keywords are set
      | Keywords                     | Category |
      | pasta, gnocchi               | Food     |
      | book, little red riding hood | Books    |
      | scalpel, malox,methadone     | Medical  |
      | imported, turkey             | Imported |
    When I run the app with the following items
      | Quantity | Product Name                 | Total Cost |
      | 1        | Imported pasta               | 12.49      |
      | 2        | Some Italian gnocchi         | 2.76       |
      | 3        | I feel Malox                 | 5.63       |
      | 4        | Let us read a book           | 12.36      |
      | 5        | Something else               | 22.77      |
      | 2        | Fancy imported Italian stuff | 10.55      |
    Then I should see a receipt with total "71.11", taxes "4.55" and items
      | Quantity | Product Name                 | Price |
      | 1        | Imported pasta               | 13.14 |
      | 2        | Some Italian gnocchi         | 2.76  |
      | 3        | I feel Malox                 | 5.63  |
      | 4        | Let us read a book           | 12.36 |
      | 5        | Something else               | 25.07 |
      | 2        | Fancy imported Italian stuff | 12.15 |
