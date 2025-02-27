import 'package:flutter/material.dart';

class Project {
  String id;
  String name;
  String description;
  String location;
  String plotNo;
  String streetNo;
  String blockSector;
  String societyName;
  String city;
  String country;
  String plotSizeInMarla;
  String plotSizeInSqFt;
  String constructionAreaInSqFt;
  String projType;
  String status;
  String startDate;
  String estimatedCost;
  String totalCost;
  String estimatedDurationInDays;
  String totalDaysIncurred;
  String clientId;
  String contractorId;
  List<String>? imageUrls;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.plotNo,
    required this.streetNo,
    required this.blockSector,
    required this.societyName,
    required this.city,
    required this.country,
    required this.plotSizeInMarla,
    required this.plotSizeInSqFt,
    required this.constructionAreaInSqFt,
    required this.projType,
    required this.status,
    required this.startDate,
    required this.estimatedCost,
    required this.totalCost,
    required this.estimatedDurationInDays,
    required this.totalDaysIncurred,
    required this.clientId,
    required this.contractorId,
    this.imageUrls,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? location,
    String? plotNo,
    String? streetNo,
    String? blockSector,
    String? societyName,
    String? city,
    String? country,
    String? plotSizeInMarla,
    String? plotSizeInSqFt,
    String? constructionAreaInSqFt,
    String? projType,
    String? status,
    String? startDate,
    String? estimatedCost,
    String? totalCost,
    String? estimatedDurationInDays,
    String? totalDaysIncurred,
    String? clientId,
    String? contractorId,
    List<String>? imageUrls,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      plotNo: plotNo ?? this.plotNo,
      streetNo: streetNo ?? this.streetNo,
      blockSector: blockSector ?? this.blockSector,
      societyName: societyName ?? this.societyName,
      city: city ?? this.city,
      country: country ?? this.country,
      plotSizeInMarla: plotSizeInMarla ?? this.plotSizeInMarla,
      plotSizeInSqFt: plotSizeInSqFt ?? this.plotSizeInSqFt,
      constructionAreaInSqFt:
          constructionAreaInSqFt ?? this.constructionAreaInSqFt,
      projType: projType ?? this.projType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      totalCost: totalCost ?? this.totalCost,
      estimatedDurationInDays:
          estimatedDurationInDays ?? this.estimatedDurationInDays,
      totalDaysIncurred: totalDaysIncurred ?? this.totalDaysIncurred,
      clientId: clientId ?? this.clientId,
      contractorId: contractorId ?? this.contractorId,
      imageUrls: imageUrls ?? this.imageUrls,
    );
  }
}

class ProjectWizard extends StatefulWidget {
  @override
  _ProjectWizardState createState() => _ProjectWizardState();
}

class _ProjectWizardState extends State<ProjectWizard> {
  int _currentStep = 0;
  Set<int> _completedSteps = {}; // Track completed steps
  Project _project = Project(
    id: '1', // Provide a default ID or generate one
    name: '',
    description: '',
    location: '',
    plotNo: '',
    streetNo: '',
    blockSector: '',
    societyName: '',
    city: '',
    country: '',
    plotSizeInMarla: '',
    plotSizeInSqFt: '',
    constructionAreaInSqFt: '',
    projType: '',
    status: '',
    startDate: '',
    estimatedCost: '',
    totalCost: '',
    estimatedDurationInDays: '',
    totalDaysIncurred: '',
    clientId: '',
    contractorId: '',
    imageUrls: [],
  );

  List<Step> _steps() {
    return [
      Step(
        title: Text(
          'Basic Information',
          style: TextStyle(
            fontWeight: _completedSteps.contains(0)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Project Name'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(name: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(description: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Location'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(location: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Project Type'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(projType: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Status'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(status: value);
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text(
          'Address Details',
          style: TextStyle(
            fontWeight: _completedSteps.contains(1)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Plot No'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(plotNo: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Street No'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(streetNo: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Block/Sector'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(blockSector: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Society Name'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(societyName: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'City'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(city: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Country'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(country: value);
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text(
          'Plot & Construction Details',
          style: TextStyle(
            fontWeight: _completedSteps.contains(2)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Plot Size (Marla)'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(plotSizeInMarla: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Plot Size (Sq Ft)'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(plotSizeInSqFt: value);
                });
              },
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Construction Area (Sq Ft)'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(constructionAreaInSqFt: value);
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: Text(
          'Project Timeline & Cost',
          style: TextStyle(
            fontWeight: _completedSteps.contains(2)
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Start Date'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(startDate: value);
                });
              },
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Estimated Duration (Days)'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(estimatedDurationInDays: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Estimated Cost'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(estimatedCost: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Cost'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(totalCost: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Total Days Incurred'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(totalDaysIncurred: value);
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: Text('Client & Contractor Details'),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Client ID'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(clientId: value);
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Contractor ID'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(contractorId: value);
                });
              },
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Image URLs (comma separated)'),
              onChanged: (value) {
                setState(() {
                  _project = _project.copyWith(imageUrls: value.split(','));
                });
              },
            ),
          ],
        ),
        isActive: _currentStep >= 4,
      ),
    ];
  }

  void _stepContinue() {
    setState(() {
      _completedSteps.add(_currentStep); // Mark step as completed
      if (_currentStep < _steps().length - 1) {
        _currentStep += 1;
      } else {
        _showFinishDialog();
      }
    });
  }

  void _stepCancel() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Project Created'),
          content: Text('Your project has been successfully created.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Project'),
      ),
      body: Theme(
        data: ThemeData(
            colorScheme: ColorScheme.light(
                primary: Colors.orange)), // Change step color to orange(
        child: Stepper(
          currentStep: _currentStep,
          steps: _steps(),
          onStepContinue: _stepContinue,
          onStepCancel: _stepCancel,
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  if (_currentStep != 0)
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: Text('Back'),
                    ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == _steps().length - 1
                        ? 'Finish'
                        : 'Next'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ProjectWizard(),
  ));
}
