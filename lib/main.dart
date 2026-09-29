import 'package:flutter/material.dart';

void main() {
  runApp(const BookNest());
}

class BookNest extends StatelessWidget {
  const BookNest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BookNest",
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const LibraryPage(),
    );
  }
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  List<String> books = [
    "The Alchemist",
    "Atomic Habits",
    "Harry Potter",
  ];

  List<String> authors = [
    "Paulo Coelho",
    "James Clear",
    "J.K. Rowling",
  ];

  List<String> categories = [
    "Fiction",
    "Self Help",
    "Fantasy",
  ];

  List<bool> read = [true, false, false];
  List<bool> favorite = [true, false, false];
  List<int> progress = [100, 40, 80];

  String search = "";

  void addBook() {
    TextEditingController bookController = TextEditingController();
    TextEditingController authorController = TextEditingController();

    String selectedCategory = "Fiction";
    double selectedProgress = 0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add a Book"),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: bookController,
                      decoration: const InputDecoration(
                        labelText: "Book Name",
                        prefixIcon: Icon(Icons.book),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: authorController,
                      decoration: const InputDecoration(
                        labelText: "Author Name",
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),

                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: "Category",
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Fiction",
                          child: Text("Fiction"),
                        ),
                        DropdownMenuItem(
                          value: "Self Help",
                          child: Text("Self Help"),
                        ),
                        DropdownMenuItem(
                          value: "Fantasy",
                          child: Text("Fantasy"),
                        ),
                        DropdownMenuItem(
                          value: "Education",
                          child: Text("Education"),
                        ),
                        DropdownMenuItem(
                          value: "General",
                          child: Text("General"),
                        ),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "Reading Progress: ${selectedProgress.toInt()}%",
                    ),

                    Slider(
                      value: selectedProgress,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: "${selectedProgress.toInt()}%",
                      onChanged: (value) {
                        setDialogState(() {
                          selectedProgress = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    if (bookController.text.isNotEmpty) {
                      setState(() {
                        books.add(bookController.text);

                        authors.add(
                          authorController.text.isEmpty
                              ? "Unknown Author"
                              : authorController.text,
                        );

                        categories.add(selectedCategory);
                        read.add(selectedProgress == 100);
                        favorite.add(false);
                        progress.add(selectedProgress.toInt());
                      });

                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showBookDetails(int index) {
    double currentProgress = progress[index].toDouble();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(books[index]),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Author: ${authors[index]}"),

                  const SizedBox(height: 8),

                  Text("Category: ${categories[index]}"),

                  const SizedBox(height: 8),

                  Text(
                    "Status: ${read[index] ? "Read" : "Unread"}",
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Reading Progress: ${currentProgress.toInt()}%",
                  ),

                  Slider(
                    value: currentProgress,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: "${currentProgress.toInt()}%",
                    onChanged: (value) {
                      setDialogState(() {
                        currentProgress = value;
                      });

                      setState(() {
                        progress[index] = value.toInt();
                        read[index] = value == 100;
                      });
                    },
                  ),
                ],
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteBook(int index) {
    setState(() {
      books.removeAt(index);
      authors.removeAt(index);
      categories.removeAt(index);
      read.removeAt(index);
      favorite.removeAt(index);
      progress.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    int readCount = read.where((item) => item).length;

    int favoriteCount =
        favorite.where((item) => item).length;

    List<int> visibleBooks = [];

    for (int i = 0; i < books.length; i++) {
      if (books[i]
          .toLowerCase()
          .contains(search.toLowerCase())) {
        visibleBooks.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("BookNest"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "My Personal Library",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              decoration: const InputDecoration(
                hintText: "Search books...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),

              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                Text("Books: ${books.length}"),
                Text("Read: $readCount"),
                Text(
                  "Unread: ${books.length - readCount}",
                ),
                Text("Favorites: $favoriteCount"),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: visibleBooks.length,

                itemBuilder: (context, position) {
                  int index = visibleBooks[position];

                  return Card(
                    margin:
                        const EdgeInsets.only(bottom: 10),

                    child: ListTile(
                      onTap: () {
                        showBookDetails(index);
                      },

                      leading: const CircleAvatar(
                        child: Icon(Icons.menu_book),
                      ),

                      title: Text(
                        books[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(authors[index]),
                          Text(categories[index]),

                          const SizedBox(height: 5),

                          LinearProgressIndicator(
                            value: progress[index] / 100,
                          ),

                          Text(
                            "${progress[index]}% completed",
                          ),
                        ],
                      ),

                      isThreeLine: true,

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              favorite[index]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: favorite[index]
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                favorite[index] =
                                    !favorite[index];
                              });
                            },
                          ),

                          IconButton(
                            icon: Icon(
                              read[index]
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: read[index]
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                read[index] =
                                    !read[index];

                                if (read[index]) {
                                  progress[index] = 100;
                                }
                              });
                            },
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteBook(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}