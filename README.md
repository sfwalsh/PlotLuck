<!-- ABOUT THE PROJECT -->
## About The Project
Plot Luck
Plot Luck is an iOS app designed for book lovers to manage their reading lists with ease. With Plot Luck, users can:

Add & Remove Books: Quickly add books to your reading list by searching through the vast Google Books database.

Track Progress: Keep tabs on your reading journey with status updates for each book (Unread, In Progress, or Finished).

Simplify Organization: Enjoy a clutter-free experience with a single reading list for all your books.

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites
- [Xcode 15](https://developer.apple.com/xcode/)
- iOS 17 Runtime (Available in Xcode 15)

### Setup

Note that the Google Books API Key is not checked into source control. I've attached it to my submission separately.

#### Option 1 (potential production solution):
Copy the provided `SecretsCollection.plist` into the PlotLuck/Resourcares folder, next to the info.plist file. Ensure that the 'Copy items if needed" checkbox and the `PlotLuck` target are selected.

#### Option 2 (for ease of reviewing code in this coding challenge context):
The provided API Key could also be placed directly in the `BookSearchViewFactory` when creating the GoogleBooksURLBuilder. I've added an inline comment at this location.

---

## Usage

#### Deleting an Item from the Reading List

Books can be deleted from a reading list by swiping from right to left on a reading list item, conforming to system conventions. This reveals a context menu with an edit status and a delete button.
Pulling all the way to the left removes the item from the reading list.

#### Updating Items in a Reading List.
Swiping from right to left on an item in the reading list reveals a context menu. One of the context items allows the user to update the reading status of the item.

#### Adding an Item / Additional Feature
I decided to implement the challenge's additional feature here.
The project uses the Google Books API for adding items to the user's reading list. Rather than entering the data for a book manually, a user can search for a book and add it to their reading list from here. This makes the app more user-friendly and helps maintain data accuracy.


---

## Project Overview
The project utilises MVVM + the Repository pattern with use cases.

Persistence is handled with SwiftData, and the UI is built with SwiftUI.

There are two screens in the app, each with its own `ViewFactory`. The ViewFactory is responsible for setting up dependencies between the different layers and returning a ready-to-use instance of its associated `ViewType`. 

### ReadingListView

#### ViewModel
The ViewModel is responsible for responding to user interaction from the View and deciding on what actions to take from this interaction. The implementation of the data layer actions is passed along to each of the use cases the ViewModel has access to. 
It also stores the `ReadingListItem` array, which the view uses to build its list.

#### Use Cases
The repository layer is accessed through Use Cases. For the Reading List suite of actions, namely: `AddReadingListItemUseCase`, `RemoveReadingListItemUseCase`, `UpdateReadingListItemUseCase` and `FetchReadingListItemsUseCase`. Each of these use cases has an instance of the `ReadingListRepository` attached to it.

#### Repository
Right now, the `ReadingListRepository` is a pass-through class that only accesses the `LocalReadingListDatasource`. 

However, in the interest of separation of concerns and extensibility, I decided to keep the implementation of datasource and repository separate. For example, in a real-world app, there could likely be another datasource with the user's saved reading lists that lives on an external API. In this case, it would be the role of the repository to decide whether to use the local or remote data source.

#### Datasource
The `LocalReadingListDatasource` is responsible for managing the SwiftData persistence layer. I've kept the `ReadingListDatasource` interface agnostic to the SwiftData implementation, making it simpler to swap out SwiftUI for a different persistence stack.

### BookSearchView

#### ViewModel
The ViewModel is responsible for responding to the user's search text, and executing its `FetchBooksUseCase` when the user hits Search. It hosts the array of `BookSearchResult`, which the View layer observes to build the UI. 
When the user taps "Add" on a `BookSearchResult`, the ViewModel executes the `AddReadingListItemUseCase`, and is responsible for dismissing its associated view.

#### Use Cases
The BookSearchView introduces another use case to the domain layer, `FetchBooksUseCase`. It also reuses the `AddReadingListItemUseCase` previously implemented for the `ReadingListView`.

#### Repository
Right now, the `BookSearchRepository` is a pass-through class that only accesses the lone `BookSearchDatasource` instance. 
However, it could be extended in the future to handle multiple different Book Search Providers, in which case it would be the repository's responsibility to execute a search on the correct service.

#### Datasource
The `GoogleBookSearchDatasource` is an implementation of the `BookSearchDatasource` that fetches BookSearchResults from the Google Books API, via the `Network` Interface. It is responsible for mapping the returned API model, into an agnostic domain model. This `GoogleBookSearchResult` API Model is intentionally confined to this class, as the rest of the data layer must remain ignorant as to the source of its `BookSearchResult`s, to promote a loosely coupled architecture.

In the interest of ensuring single responsibility, the URL Building function is relegated to its own class `GoogleBooksURLBuilder`.

Since all of these components are hidden behind interfaces, it should be relatively simple to swap out components for other services. For example, if we wanted to swap Google Books for Goodreads, it would be a matter of implementing a new data source conforming to `BookSearchDatasource`, and injecting it instead of the Google Books version.

---

## Potential Enhancements & Improvements

#### A UI for editing the author and title of a reading list item.
The repository and data layer structure for changing a ReadingListItem's title and author is already in place. However since the app uses Google Books for reading list item creation, I decided not to build a UI to edit the title or author name, as it didn't feel like the right experience for the app.

#### Improved "Add Item" UI
Books are unread when they are added, UI could be added to change this. Since the Use Case pattern is implemented, this could be extended quite easily since the use cases are portable and detached from the view layer.

#### Improved Error Handling
There is an ErrorLogger protocol that is called when an error surfaces from the repository layer. However, the concrete instance of this protocol `CrashlyticsErrorLogger` isn't fully implemented due to time constraints.

#### General UX Improvements
- It is currently possible to add multiple instances of the same book to the reading list.
- Change the Add button to “added” when the item is already in the reading list
- No pagination on book search, since the most relevant items for the search term are at the beginning. Due to time constraints, it wasn't pragmatic to implement this.


## Considerations while developing
Regarding the Google Books API, I investigated using the “lite” projection to save on data transferring by omitting unnecessary fields, but unfortunately, it also omits the IBSN. And so it was necessary to use the full projection.

The Google Books API also returns authors as an array. Since the challenge's specification defines `author` rather authors, I decided to map the array of authors to a comma-separated string, when multiple authors are returned.

Some objects come back from the API without an author string, I opted to replace these absent strings with a default blank value rather than omit the item entirely from the result array.
