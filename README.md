#  SwiftUI Sidebar + SplitView Example

A basic example implementing the 3 column split view as it has been introduced in iOS 14.
There are various examples and blog posts available on the web, but most of them do have some bugs or missing main feature.

## Goals

The goal for my example project was to:

- have a sidebar, remembering its current selection and highlighting it accordingly
- content is a regular Master/Detail resp. Primary/Supplemental view, also remembering the current list selection

These seem rather basic goals, but most of them are not easily achieved with the examples and blog posts I've found so far.

The basic setup of a three column split view is created as follows:

```swift
NavigationView {
    SidebarList()
    PrimaryView()
    SupplementalView()
}
```

Whenever a list row is selected from the sidebar, this influences the content of the primary view.  
When a list entry in the primary view is selected, this will influence the content of the supplemental view.

## The problems

During the implementation, I've hit the following problems and had to find appropriate solutions.

1. List selection is not easily remembered: `AppStorage` does not support optional types (which are in general
   used by `NavigationLink`s `selection` parameter to remember the currently selected entry)

2. A programmatically triggered `NavigationLink` (i.e. setting the `selection` to the correct `tag`) will trigger the 
    display of the destination view, but it will not highlight the row/link as selected.  
    The programmatically selected sidebar entry will not be displayed as long as the sidebar is shown by the user.
    (e.g. on an iPhone and 11" iPad the sidebar is hidden by default!)

3. Especially disturbing: the initially displayed `PrimaryView` and `SupplementalView` are treated as placeholders and are
    **replaced/overwritten** even though a user clicks the exact same rows which correspond to the content of those views.
    (=a `onDisappear` and a fresh `onAppear` is triggered.)

4. I have not found a modifier to set a list row to "selected" or "highlighted", even though the regular lists do support
    selection/highlighting when the corresponding `NavigationLink` is tapped by the user.

5. Selecting a different Primary view will not automatically invalidate/clear the supplemental view. 

6. It might happen that a title set using the `navigationTitle` modifier, is not cleared/removed if a new view is displayed 
    which does not have such a modifier. 

## The key findings

1. **Do not use `NavigationLink` to change the views displayed in the primary view and supplemental view.**  

    First: the `NavigationLink` cannot be used to properly track the selected item within the list due to the fact that the
    `tag:,selection:` arguments resp. the `isActive:` is mainly used to animate the navigation to a detail view respectively
    away from the detail view. Therefore I've introduces `selectedCategory` and `selectedItem` in my model. They are set
    whenever a tap action happens on the list row.  
    This means: I have used regular `Text` views with `onTapGesture` gesture recognisers to detect tapping on a list row.
    
2. **Highlighting the list selection requires different approaches for a regular list and the sidebar list.**  

    SwiftUI has no modifier to "select" or "highlight" a row within a list. You can either modify the row displayed by appending
    a chevron or you can override the list background by using the `listRowBackground` modifier.  
    This sounds easy and straight forward, but first `listRowBackground` cannot be used in the sidebar list as it will break
    the default iOS layout implemented in the sidebar. Second it is not (easily or at all?) possible to create a background view
    covering the whole area of the list row. There always seems to be some padding left.  
    This is the reason why I've chosen to use the "chevron highlighting" in the sidebar and an additional background color change
    in the regular list shown in the primary view.

3. **Do not expect all three columns being displayed at the same time on a "small iPad" (10.2" or 11")**

    If not all three columns are shown, there will always be an ugly "< Back" button in the top left similar to the iPhones.  
    Only a 12.9" iPad Pro held in landscape mode will show the button the show/hide the sidebar. 

4. **It is not possible to switch between three column split view and two column split view.**

    If you want three column mode, you will have to provide 3 child views to `NavigationView`. Conditionnally omitting the
    third view will not change the layout. There will simply be a missing supplemental view!
