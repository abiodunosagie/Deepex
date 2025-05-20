// lib/screens/transactions_screen.dart
import 'package:deepex/constants/app_colors.dart';
import 'package:deepex/constants/spacing.dart';
import 'package:deepex/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Airtime', 'Bills', 'Data', 'Transfer'];

  // Mock transaction data
  List<TransactionModel> _transactions = [];
  List<TransactionModel> _filteredTransactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();

    // Simulate loading transactions
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _transactions = [
          TransactionModel(
            id: '1001',
            type: TransactionType.debit,
            amount: 5000.00,
            description: 'MTN Airtime Recharge',
            date: DateTime.now().subtract(const Duration(hours: 2)),
            status: TransactionStatus.completed,
            category: TransactionCategory.airtime,
            reference: 'AIR-MT-1001',
            recipientInfo: '09012345678',
          ),
          TransactionModel(
            id: '1002',
            type: TransactionType.debit,
            amount: 12500.00,
            description: 'DSTV Premium Subscription',
            date: DateTime.now().subtract(const Duration(days: 1)),
            status: TransactionStatus.completed,
            category: TransactionCategory.utility,
            reference: 'TV-DS-1002',
            recipientInfo: '1122334455',
          ),
          TransactionModel(
            id: '1003',
            type: TransactionType.credit,
            amount: 50000.00,
            description: 'Bank Transfer from John Doe',
            date: DateTime.now().subtract(const Duration(days: 2)),
            status: TransactionStatus.completed,
            category: TransactionCategory.bankTransfer,
            reference: 'BNK-TR-1003',
            senderInfo: 'John Doe • GTBank',
          ),
          TransactionModel(
            id: '1004',
            type: TransactionType.debit,
            amount: 8500.00,
            description: 'Electricity Bill - EKEDC',
            date: DateTime.now().subtract(const Duration(days: 3)),
            status: TransactionStatus.pending,
            category: TransactionCategory.electricity,
            reference: 'ELE-EK-1004',
            recipientInfo: '01234567890',
          ),
          TransactionModel(
            id: '1005',
            type: TransactionType.debit,
            amount: 3000.00,
            description: 'Glo Data Bundle - 10GB',
            date: DateTime.now().subtract(const Duration(days: 5)),
            status: TransactionStatus.completed,
            category: TransactionCategory.data,
            reference: 'DATA-GL-1005',
            recipientInfo: '08012345678',
          ),
          TransactionModel(
            id: '1006',
            type: TransactionType.credit,
            amount: 15000.00,
            description: 'Gift Card Redemption',
            date: DateTime.now().subtract(const Duration(days: 7)),
            status: TransactionStatus.completed,
            category: TransactionCategory.giftCard,
            reference: 'GC-AMZ-1006',
          ),
          TransactionModel(
            id: '1007',
            type: TransactionType.debit,
            amount: 2500.00,
            description: 'Airtime Purchase - Airtel',
            date: DateTime.now().subtract(const Duration(days: 10)),
            status: TransactionStatus.failed,
            category: TransactionCategory.airtime,
            reference: 'AIR-AT-1007',
            recipientInfo: '07012345678',
            failureReason: 'Network timeout',
          ),
          TransactionModel(
            id: '1008',
            type: TransactionType.debit,
            amount: 35000.00,
            description: 'Bank Transfer to Jane Smith',
            date: DateTime.now().subtract(const Duration(days: 12)),
            status: TransactionStatus.completed,
            category: TransactionCategory.bankTransfer,
            reference: 'BNK-TR-1008',
            recipientInfo: 'Jane Smith • First Bank',
          ),
          TransactionModel(
            id: '1009',
            type: TransactionType.credit,
            amount: 20000.00,
            description: 'Wallet Deposit',
            date: DateTime.now().subtract(const Duration(days: 15)),
            status: TransactionStatus.completed,
            category: TransactionCategory.deposit,
            reference: 'DEP-WL-1009',
          ),
        ];

        _filteredTransactions = List.from(_transactions);
        _isLoading = false;
      });
    });

    _tabController.addListener(() {
      _filterTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    final searchQuery = _searchController.text.toLowerCase();
    final isAll = _selectedFilter == 'All';

    setState(() {
      if (_tabController.index == 0) { // All transactions
        _filteredTransactions = _transactions.where((transaction) {
          final matchesSearch = searchQuery.isEmpty ||
              transaction.description.toLowerCase().contains(searchQuery) ||
              transaction.reference.toLowerCase().contains(searchQuery);

          final matchesFilter = isAll ||
              transaction.category
                  .toString()
                  .split('.')
                  .last
                  .contains(_selectedFilter.toLowerCase());

          return matchesSearch && matchesFilter;
        }).toList();
      } else { // Pending transactions
        _filteredTransactions = _transactions.where((transaction) {
          final matchesSearch = searchQuery.isEmpty ||
              transaction.description.toLowerCase().contains(searchQuery) ||
              transaction.reference.toLowerCase().contains(searchQuery);

          final matchesFilter = isAll ||
              transaction.category
                  .toString()
                  .split('.')
                  .last
                  .contains(_selectedFilter.toLowerCase());

          return transaction.status == TransactionStatus.pending &&
              matchesSearch && matchesFilter;
        }).toList();
      }
    });
  }

  void _openTransactionDetails(TransactionModel transaction) {
    // In a real app, we would navigate to a transaction details page
    // For now, let's just show the details in a modal

    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final primaryColor = isDarkMode ? AppColors.primaryLight : AppColors
        .primary;
    final backgroundColor = isDarkMode
        ? AppColors.backgroundDarkElevated
        : Colors.white;
    final textColor = isDarkMode ? AppColors.textDarkPrimary : AppColors
        .textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkSecondary
        : AppColors.textLightSecondary;
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.75,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey.withAlpha(77) : Colors.grey
                        .withAlpha(51),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Transaction status banner
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        decoration: BoxDecoration(
                          color: _getStatusColor(transaction.status).withAlpha(
                              26),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getStatusColor(transaction.status)
                                .withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(transaction.status)
                                    .withAlpha(51),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getStatusIcon(transaction.status),
                                color: _getStatusColor(transaction.status),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getStatusText(transaction.status),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(transaction.status),
                                  ),
                                ),
                                Text(
                                  _getStatusDescription(transaction.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Transaction amount
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                transaction.type == TransactionType.credit
                                    ? Iconsax.arrow_down
                                    : Iconsax.arrow_up,
                                color: transaction.type ==
                                    TransactionType.credit
                                    ? AppColors.success
                                    : AppColors.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                formatter.format(transaction.amount),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Transaction details
                      _buildDetailRow(
                        label: 'Transaction Type',
                        value: _getCategoryText(transaction.category),
                        icon: _getCategoryIcon(transaction.category),
                        iconColor: primaryColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),

                      const SizedBox(height: 16),

                      _buildDetailRow(
                        label: 'Date & Time',
                        value: DateFormat('MMM dd, yyyy - HH:mm').format(
                            transaction.date),
                        icon: Iconsax.calendar,
                        iconColor: primaryColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),

                      const SizedBox(height: 16),

                      _buildDetailRow(
                        label: 'Reference',
                        value: transaction.reference,
                        icon: Iconsax.document_code,
                        iconColor: primaryColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        showCopy: true,
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: transaction
                              .reference))
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Reference copied to clipboard'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.9,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      if (transaction.senderInfo != null)
                        _buildDetailRow(
                          label: 'Sender',
                          value: transaction.senderInfo!,
                          icon: Iconsax.user,
                          iconColor: primaryColor,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                        ),

                      if (transaction.recipientInfo != null)
                        Padding(
                          padding: EdgeInsets.only(
                              top: transaction.senderInfo != null ? 16 : 0),
                          child: _buildDetailRow(
                            label: 'Recipient',
                            value: transaction.recipientInfo!,
                            icon: Iconsax.user_tick,
                            iconColor: primaryColor,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                          ),
                        ),

                      if (transaction.status == TransactionStatus.failed &&
                          transaction.failureReason != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildDetailRow(
                            label: 'Failure Reason',
                            value: transaction.failureReason!,
                            icon: Iconsax.info_circle,
                            iconColor: AppColors.error,
                            textColor: textColor,
                            secondaryTextColor: secondaryTextColor,
                          ),
                        ),

                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),

                      // Action buttons
                      Row(
                        children: [
                          if (transaction.status == TransactionStatus.failed)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle retry logic
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Retry Transaction'),
                              ),
                            ),

                          if (transaction.status == TransactionStatus.failed)
                            const SizedBox(width: 12),

                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                // Handle support action
                                Navigator.pop(context);
                                context.push('/support');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryColor,
                                side: BorderSide(color: primaryColor),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Get Support'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color textColor,
    required Color secondaryTextColor,
    bool showCopy = false,
    VoidCallback? onCopy,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(26),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  if (showCopy)
                    InkWell(
                      onTap: onCopy,
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: iconColor.withAlpha(26),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Iconsax.copy,
                          color: iconColor,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return AppColors.success;
      case TransactionStatus.pending:
        return AppColors.warning;
      case TransactionStatus.failed:
        return AppColors.error;
    }
  }

  IconData _getStatusIcon(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return Iconsax.tick_circle;
      case TransactionStatus.pending:
        return Iconsax.timer;
      case TransactionStatus.failed:
        return Iconsax.close_circle;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'Transaction Successful';
      case TransactionStatus.pending:
        return 'Transaction Pending';
      case TransactionStatus.failed:
        return 'Transaction Failed';
    }
  }

  String _getStatusDescription(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.completed:
        return 'This transaction has been completed successfully';
      case TransactionStatus.pending:
        return 'This transaction is still being processed';
      case TransactionStatus.failed:
        return 'This transaction could not be completed';
    }
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.airtime:
        return Iconsax.mobile;
      case TransactionCategory.data:
        return Iconsax.wifi;
      case TransactionCategory.utility:
        return Iconsax.building;
      case TransactionCategory.electricity:
        return Iconsax.electricity;
      case TransactionCategory.bankTransfer:
        return Iconsax.bank;
      case TransactionCategory.giftCard:
        return Iconsax.card;
      case TransactionCategory.deposit:
        return Iconsax.wallet_add; // Wallet with plus sign icon
    }
  }

  String _getCategoryText(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.airtime:
        return 'Airtime Purchase';
      case TransactionCategory.data:
        return 'Data Purchase';
      case TransactionCategory.utility:
        return 'Utility Payment';
      case TransactionCategory.electricity:
        return 'Electricity Payment';
      case TransactionCategory.bankTransfer:
        return 'Bank Transfer';
      case TransactionCategory.giftCard:
        return 'Gift Card';
      case TransactionCategory.deposit:
        return 'Wallet Deposit';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? AppColors.backgroundDark : AppColors
        .backgroundLight;
    final textColor = isDarkMode ? AppColors.textDarkPrimary : AppColors
        .textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkSecondary
        : AppColors.textLightSecondary;
    final cardColor = isDarkMode ? AppColors.backgroundDarkElevated : Colors
        .white;
    final primaryColor = isDarkMode ? AppColors.primaryLight : AppColors
        .primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Transactions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and filter section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Search bar
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(isDarkMode ? 26 : 13),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Search transactions',
                      hintStyle: TextStyle(color: secondaryTextColor),
                      prefixIcon: Icon(
                          Iconsax.search_normal, color: secondaryTextColor,
                          size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) {
                      _filterTransactions();
                    },
                  ),
                ),

                Spacing.verticalM,

                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;

                      return Padding(
                        padding: EdgeInsets.only(
                          right: index < _filters.length - 1 ? 8 : 0,
                        ),
                        child: FilterChip(
                          selected: isSelected,
                          showCheckmark: false,
                          label: Text(filter),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : secondaryTextColor,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          backgroundColor: isDarkMode
                              ? AppColors.backgroundDarkSecondary
                              : AppColors.backgroundLightSecondary,
                          selectedColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected
                                  ? primaryColor
                                  : Colors.transparent,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = filter;
                              _filterTransactions();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 26 : 13),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: secondaryTextColor,
              indicatorColor: primaryColor,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              onTap: (_) {
                _filterTransactions();
              },
              tabs: const [
                Tab(text: 'All Transactions'),
                Tab(text: 'Pending'),
              ],
            ),
          ),

          // Transaction list
          Expanded(
            child: _isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
                : _filteredTransactions.isEmpty
                ? _buildEmptyState(textColor, secondaryTextColor)
                : TabBarView(
              controller: _tabController,
              children: [
                // All Transactions tab
                _buildTransactionsList(context),

                // Pending tab
                _buildTransactionsList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color textColor, Color secondaryTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Iconsax.receipt_search,
            size: 64,
            color: Colors.grey,
          ),
          Spacing.verticalM,
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          Spacing.verticalS,
          Text(
            _tabController.index == 0
                ? 'Try changing your search filters'
                : 'You don\'t have any pending transactions',
            style: TextStyle(
              fontSize: 14,
              color: secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          Spacing.verticalL,
          if (_tabController.index == 0 && _searchController.text.isNotEmpty)
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedFilter = 'All';
                  _filterTransactions();
                });
              },
              icon: const Icon(Iconsax.filter_remove),
              label: const Text('Clear Filters'),
            ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final cardColor = isDarkMode ? AppColors.backgroundDarkElevated : Colors
        .white;
    final textColor = isDarkMode ? AppColors.textDarkPrimary : AppColors
        .textLightPrimary;
    final secondaryTextColor = isDarkMode
        ? AppColors.textDarkSecondary
        : AppColors.textLightSecondary;

    // Group transactions by date
    final groupedTransactions = <String, List<TransactionModel>>{};

    for (final transaction in _filteredTransactions) {
      final dateKey = DateFormat('MMMM dd, yyyy').format(transaction.date);
      if (groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey]!.add(transaction);
      } else {
        groupedTransactions[dateKey] = [transaction];
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final transactions = groupedTransactions[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                dateKey,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),

            // Transactions for this date
            ...transactions.map((transaction) =>
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => _openTransactionDetails(transaction),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDarkMode ? 26 : 13),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Category icon
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(
                                  transaction.category, isDarkMode).withAlpha(
                                  26),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getCategoryIcon(transaction.category),
                              color: _getCategoryColor(
                                  transaction.category, isDarkMode),
                            ),
                          ),

                          const SizedBox(width: 15),

                          // Transaction details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction.description,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    // Status indicator
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                            transaction.status),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      transaction.status
                                          .toString()
                                          .split('.')
                                          .last
                                          .capitalize(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '•',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('HH:mm').format(
                                          transaction.date),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Amount
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    transaction.type == TransactionType.credit
                                        ? Iconsax.arrow_down
                                        : Iconsax.arrow_up,
                                    color: transaction.type ==
                                        TransactionType.credit
                                        ? AppColors.success
                                        : AppColors.error,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatter.format(transaction.amount),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: transaction.type ==
                                          TransactionType.credit
                                          ? AppColors.success
                                          : textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction.reference,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),

            // Add some extra spacing between date groups
            if (index < groupedTransactions.length - 1)
              const SizedBox(height: 10),
          ],
        );
      },
    );
  }

  Color _getCategoryColor(TransactionCategory category, bool isDarkMode) {
    switch (category) {
      case TransactionCategory.airtime:
        return isDarkMode ? AppColors.airtimeLight : AppColors.airtime;
      case TransactionCategory.data:
        return isDarkMode ? AppColors.dataLight : AppColors.data;
      case TransactionCategory.utility:
        return isDarkMode ? AppColors.secondaryLight : AppColors.secondary;
      case TransactionCategory.electricity:
        return isDarkMode ? AppColors.electricityLight : AppColors.electricity;
      case TransactionCategory.bankTransfer:
        return isDarkMode ? AppColors.primaryLight : AppColors.primary;
      case TransactionCategory.giftCard:
        return isDarkMode ? AppColors.giftCardLight : AppColors.giftCard;
      case TransactionCategory.deposit:
        return isDarkMode
            ? const Color(0xFF66BB6A) // Light green for dark mode
            : const Color(0xFF43A047); // Green for light mode
    }
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}