import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/category/category_bloc.dart';
import 'package:inovest/business_logics/ideas/ideas_bloc.dart';
import 'package:inovest/business_logics/category/category_event.dart';
import 'package:inovest/business_logics/category/category_state.dart';
import 'package:inovest/data/models/category_model.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/index.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  CategoryModel? selectedCategory;
  RangeValues _currentRangeValues = const RangeValues(100, 100000);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _abstractController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<GetCategoriesBloc>().add(FetchCategoriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppArray().colors[1],
      appBar: AppBar(
        backgroundColor: AppArray().colors[1],
        title: Text(
          'Add new project',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.r),
            child: CircleAvatar(radius: 23),
          ),
        ],
      ),
      body: BlocListener<IdeasBloc, IdeasState>(
        listener: (context, state) {
          if (state is CreatedIdeas) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Project created successfully!')),
            );
            Navigator.pop(context, state.ideas);
          } else if (state is IdeasError) {
            log(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 25.r, right: 25.r, top: 20.r),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Project Name'),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: _titleController,
                    decoration: _inputDecoration('Enter name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Project name is required';
                      }
                      if (value.length < 5) {
                        return 'Project name must be at least 5 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel('Industry'),
                  SizedBox(height: 10.h),
                  BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
                    builder: (context, state) {
                      if (state is GetCategoryLoading) {
                        return Center(child: CircularProgressIndicator());
                      }else  if (state is GetCategoryLoaded) {
                        return DropdownButtonFormField<CategoryModel>(
                          decoration: _inputDecoration('Select Industry'),
                          items: state.categories.map((CategoryModel category) {
                            return DropdownMenuItem<CategoryModel>(
                              value: category,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (CategoryModel? value) {
                            setState(() {
                              selectedCategory = value;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Please select an industry'
                              : null,
                        );
                      } else if (state is GetCategoryError) {
                        return Text('Error: ${state.error}');
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel('Project Abstract'),
                  SizedBox(height: 10.h),
                  TextFormField(
                    controller: _abstractController,
                    maxLines: 5,
                    decoration:
                        _inputDecoration('Enter abstract (min. 20 characters)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Abstract is required';
                      } else if (value.length < 20) {
                        return 'Abstract must be at least 20 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('Expecting Investment'),
                      Text(
                        '\$${_currentRangeValues.start.toInt()} - \$${_currentRangeValues.end.toInt()}',
                        style: TextStyle(
                            fontSize: 16.h, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(thumbColor: AppArray().colors[5],activeTrackColor:Colors.grey[200] ,inactiveTrackColor:AppArray().colors[5] ),
                    child: RangeSlider(
                      values: _currentRangeValues,
                      min: 100,
                      max: 100000,
                      divisions: 1000,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 60.h),
                  BlocBuilder<IdeasBloc, IdeasState>(
                    builder: (context, state) {
                      return Center(
                        child: SizedBox(
                          width: 200.w,
                          child: ElevatedButton(
                            onPressed: state is IdeasLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      if (selectedCategory != null) {
                                        context.read<IdeasBloc>().add(
                                              CreateIdeas(
                                                title: _titleController.text,
                                                abstract: _abstractController.text,
                                                expectedInvestment:
                                                    _currentRangeValues.end
                                                        .toDouble(),
                                                categoryId: selectedCategory!.id,
                                              ),
                                            );
                                            Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Please select an industry'),
                                          ),
                                        );
                                      }
                                    }
                                  },
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                  AppArray().colors[2]),
                              foregroundColor: WidgetStatePropertyAll(
                                  AppArray().colors[1]),
                            ),
                            child:Text('Submit'),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 16.h));
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: AppArray().colors[3]),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppArray().colors[3]),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppArray().colors[3]),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
