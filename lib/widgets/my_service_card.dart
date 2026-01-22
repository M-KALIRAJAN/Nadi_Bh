import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/CommonNetworkImage.dart';

import 'package:nadi_user_app/core/utils/Time_Date.dart';
class ServiceRequestCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String serviceStatus;
  final String serviceLogo;
  final VoidCallback onViewDetails;

  const ServiceRequestCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.serviceStatus,
    required this.serviceLogo,
    required this.onViewDetails,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10 ),
            child: Container(
              decoration: BoxDecoration(
               borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15)
               ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12), 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: serviceStatus == "submitted"
                                ? AppColors.button_secondary
                                : serviceStatus == "paymentInProgress"
                                ? AppColors.gold_coin
                                : serviceStatus == "accepted"
                                ? AppColors.button_secondary
                                : serviceStatus == "inProgress"
                                ? Colors.grey
                                : serviceStatus == "technicianAssigned"
                                ? const Color.fromARGB(255, 160, 227, 208)
                                : null,
                          ),
                          child: CommonNetworkImage(
                            imageUrl: "${ImageBaseUrl.baseUrl}/$serviceLogo",
                            size: 40,
                          ),
                        ),
      
                        const SizedBox(width: 14),
      
                        /// Title & Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                               formatIsoDateForUI(date),
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  color: AppColors.borderGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
      
                        /// Status Chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: serviceStatus == "submitted"
                                ? AppColors.btn_primery
                                : serviceStatus == "paymentInProgress"
                                ?AppColors.gold_coin
                                : serviceStatus == "accepted"
                                ? AppColors.btn_primery
                                : serviceStatus == "inProgress"
                                ? Colors.grey
                                : serviceStatus == "technicianAssigned"
                                ? AppColors.button_secondary
                                : null,
                          ),
                          child: Text(
                            serviceStatus == "technicianAssigned"
                                ? "Assigned" 
                                :serviceStatus == "inProgress" ? "InProgress"
                                 :serviceStatus == "accepted" ? "Accepted"
                                  :serviceStatus == "submitted" ? "Submitted"
                                : serviceStatus,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
      
                    const SizedBox(height: 8),
      
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: AppColors.borderGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: onViewDetails,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.btn_primery,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Text(
                  "View Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
