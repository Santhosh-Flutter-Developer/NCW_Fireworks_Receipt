import '../models/party_model.dart';
import '../models/product_model.dart';
import '../models/billing_item_model.dart';
import '../models/quotation_model.dart';
import '../models/estimation_model.dart';
import '../models/stock_adjustment_model.dart';

/// Centralized dummy/mock data used to power the UI before the
/// Supabase backend is wired up. Replace each generator with a
/// repository call when the backend is ready.
class DummyData {
  DummyData._();

  /// Agents shown in the Agent dropdown on both the Party list filter
  /// and the Add/Edit Party form, matching the web app.
  static const List<String> agents = [
    'Mahendran',
    'Karthik',
    'Priya Dharshini',
  ];

  static const List<String> states = [
    'Andaman And Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Orissa',
    'Pondicherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  static const Map<String, List<String>> districtsByState = {
    'Andaman And Nicobar Islands': ['Nicobar', 'North and Middle Andaman', 'South Andaman'],
    'Andhra Pradesh': ['Anantapur', 'Chittoor', 'East Godavari', 'Guntur', 'Krishna', 'Kurnool', 'Nellore', 'Prakasam', 'Srikakulam', 'Visakhapatnam', 'Vizianagaram', 'West Godavari', 'YSR Kadapa'],
    'Arunachal Pradesh': ['Anjaw', 'Changlang', 'Dibang Valley', 'East Kameng', 'East Siang', 'Kra Daadi', 'Kurung Kumey', 'Lohit', 'Longding', 'Lower Dibang Valley', 'Lower Siang', 'Lower Subansiri', 'Namsai', 'Papum Pare', 'Siang', 'Tawang', 'Tirap', 'Upper Siang', 'Upper Subansiri', 'West Kameng', 'West Siang'],
    'Assam': ['Baksa', 'Barpeta', 'Biswanath', 'Bongaigaon', 'Cachar', 'Charaideo', 'Chirang', 'Darrang', 'Dhemaji', 'Dhubri', 'Dibrugarh', 'Dima Hasao', 'Goalpara', 'Golaghat', 'Hailakandi', 'Hojai', 'Jorhat', 'Kamrup', 'Kamrup Metropolitan', 'Karbi Anglong', 'Karimganj', 'Kokrajhar', 'Lakhimpur', 'Majuli', 'Morigaon', 'Nagaon', 'Nalbari', 'Sivasagar', 'Sonitpur', 'South Salmara-Mankachar', 'Tinsukia', 'Udalguri', 'West Karbi Anglong'],
    'Bihar': ['Araria', 'Arwal', 'Aurangabad', 'Banka', 'Begusarai', 'Bhagalpur', 'Bhojpur', 'Buxar', 'Darbhanga', 'East Champaran (Motihari)', 'Gaya', 'Gopalganj', 'Jamui', 'Jehanabad', 'Kaimur (Bhabua)', 'Katihar', 'Khagaria', 'Kishanganj', 'Lakhisarai', 'Madhepura', 'Madhubani', 'Munger (Monghyr)', 'Muzaffarpur', 'Nalanda', 'Nawada', 'Patna', 'Purnia (Purnea)', 'Rohtas', 'Saharsa', 'Samastipur', 'Saran', 'Sheikhpura', 'Sheohar', 'Sitamarhi', 'Siwan', 'Supaul', 'Vaishali', 'West Champaran'],
    'Chandigarh': ['Chandigarh'],
    'Chhattisgarh': ['Balod', 'Baloda Bazar', 'Balrampur', 'Bastar', 'Bemetara', 'Bijapur', 'Bilaspur', 'Dantewada (South Bastar)', 'Dhamtari', 'Durg', 'Gariyaband', 'Janjgir-Champa', 'Jashpur', 'Kabirdham (Kawardha)', 'Kanker (North Bastar)', 'Kondagaon', 'Korba', 'Korea (Koriya)', 'Mahasamund', 'Mungeli', 'Narayanpur', 'Raigarh', 'Raipur', 'Rajnandgaon', 'Sukma', 'Surajpur  ', 'Surguja'],
    'Dadra and Nagar Haveli': ['Dadra & Nagar Haveli'],
    'Daman and Diu': ['Daman', 'Diu'],
    'Delhi': ['Central Delhi', 'East Delhi', 'New Delhi', 'North Delhi', 'North East  Delhi', 'North West  Delhi', 'Shahdara', 'South Delhi', 'South East Delhi', 'South West  Delhi', 'West Delhi'],
    'Goa': ['North Goa', 'South Goa'],
    'Gujarat': ['Ahmedabad', 'Amreli', 'Anand', 'Aravalli', 'Banaskantha (Palanpur)', 'Bharuch', 'Bhavnagar', 'Botad', 'Chhota Udepur', 'Dahod', 'Dangs (Ahwa)', 'Devbhoomi Dwarka', 'Gandhinagar', 'Gir Somnath', 'Jamnagar', 'Junagadh', 'Kachchh', 'Kheda (Nadiad)', 'Mahisagar', 'Mehsana', 'Morbi', 'Narmada (Rajpipla)', 'Navsari', 'Panchmahal (Godhra)', 'Patan', 'Porbandar', 'Rajkot', 'Sabarkantha (Himmatnagar)', 'Surat', 'Surendranagar', 'Tapi (Vyara)', 'Vadodara', 'Valsad'],
    'Haryana': ['Ambala', 'Bhiwani', 'Charkhi Dadri', 'Faridabad', 'Fatehabad', 'Gurgaon', 'Hisar', 'Jhajjar', 'Jind', 'Kaithal', 'Karnal', 'Kurukshetra', 'Mahendragarh', 'Mewat', 'Palwal', 'Panchkula', 'Panipat', 'Rewari', 'Rohtak', 'Sirsa', 'Sonipat', 'Yamunanagar'],
    'Himachal Pradesh': ['Bilaspur', 'Chamba', 'Hamirpur', 'Kangra', 'Kinnaur', 'Kullu', 'Lahaul &amp; Spiti', 'Mandi', 'Shimla', 'Sirmaur (Sirmour)', 'Solan', 'Una'],
    'Jammu and Kashmir': ['Anantnag', 'Bandipore', 'Baramulla', 'Budgam', 'Doda', 'Ganderbal', 'Jammu', 'Kathua', 'Kishtwar', 'Kulgam', 'Kupwara', 'Poonch', 'Pulwama', 'Rajouri', 'Ramban', 'Reasi', 'Samba', 'Shopian', 'Srinagar', 'Udhampur'],
    'Jharkhand': ['Bokaro', 'Chatra', 'Deoghar', 'Dhanbad', 'Dumka', 'East Singhbhum', 'Garhwa', 'Giridih', 'Godda', 'Gumla', 'Hazaribag', 'Jamtara', 'Khunti', 'Koderma', 'Latehar', 'Lohardaga', 'Pakur', 'Palamu', 'Ramgarh', 'Ranchi', 'Sahibganj', 'Seraikela-Kharsawan', 'Simdega', 'West Singhbhum'],
    'Karnataka': ['Bagalkot', 'Ballari (Bellary)', 'Belagavi (Belgaum)', 'Bengaluru (Bangalore) Rural', 'Bengaluru (Bangalore) Urban', 'Bidar', 'Chamarajanagar', 'Chikballapur', 'Chikkamagaluru (Chikmagalur)', 'Chitradurga', 'Dakshina Kannada', 'Davangere', 'Dharwad', 'Gadag', 'Hassan', 'Haveri', 'Kalaburagi (Gulbarga)', 'Kodagu', 'Kolar', 'Koppal', 'Mandya', 'Mysuru (Mysore)', 'Raichur', 'Ramanagara', 'Shivamogga (Shimoga)', 'Tumakuru (Tumkur)', 'Udupi', 'Uttara Kannada (Karwar)', 'Vijayapura (Bijapur)', 'Yadgir'],
    'Kerala': ['Alappuzha', 'Ernakulam', 'Idukki', 'Kannur', 'Kasaragod', 'Kollam', 'Kottayam', 'Kozhikode', 'Malappuram', 'Palakkad', 'Pathanamthitta', 'Thiruvananthapuram', 'Thrissur', 'Wayanad'],
    'Ladakh': ['Kargil', 'Leh'],
    'Lakshadweep': ['Agatti', 'Amini', 'Androth', 'Bithra', 'Chethlath', 'Kadmath', 'Kalpeni', 'Kavaratti', 'Kilthan', 'Minicoy'],
    'Madhya Pradesh': ['Agar Malwa', 'Alirajpur', 'Anuppur', 'Ashoknagar', 'Balaghat', 'Barwani', 'Betul', 'Bhind', 'Bhopal', 'Burhanpur', 'Chhatarpur', 'Chhindwara', 'Damoh', 'Datia', 'Dewas', 'Dhar', 'Dindori', 'Guna', 'Gwalior', 'Harda', 'Hoshangabad', 'Indore', 'Jabalpur', 'Jhabua', 'Katni', 'Khandwa', 'Khargone', 'Mandla', 'Mandsaur', 'Morena', 'Narsinghpur', 'Neemuch', 'Panna', 'Raisen', 'Rajgarh', 'Ratlam', 'Rewa', 'Sagar', 'Satna', 'Sehore', 'Seoni', 'Shahdol', 'Shajapur', 'Sheopur', 'Shivpuri', 'Sidhi', 'Singrauli', 'Tikamgarh', 'Ujjain', 'Umaria', 'Vidisha'],
    'Maharashtra': ['Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara', 'Buldhana', 'Chandrapur', 'Dhule', 'Gadchiroli', 'Gondia', 'Hingoli', 'Jalgaon', 'Jalna', 'Kolhapur', 'Latur', 'Mumbai City', 'Mumbai Suburban', 'Nagpur', 'Nanded', 'Nandurbar', 'Nashik', 'Osmanabad', 'Palghar', 'Parbhani', 'Pune', 'Raigad', 'Ratnagiri', 'Sangli', 'Satara', 'Sindhudurg', 'Solapur', 'Thane', 'Wardha', 'Washim', 'Yavatmal'],
    'Manipur': ['Bishnupur', 'Chandel', 'Churachandpur', 'Imphal East', 'Imphal West', 'Jiribam', 'Kakching', 'Kamjong', 'Kangpokpi', 'Noney', 'Pherzawl', 'Senapati', 'Tamenglong', 'Tengnoupal', 'Thoubal', 'Ukhrul'],
    'Meghalaya': ['East Garo Hills', 'East Jaintia Hills', 'East Khasi Hills', 'North Garo Hills', 'Ri Bhoi', 'South Garo Hills', 'South West Garo Hills ', 'South West Khasi Hills', 'West Garo Hills', 'West Jaintia Hills', 'West Khasi Hills'],
    'Mizoram': ['Aizawl', 'Champhai', 'Kolasib', 'Lawngtlai', 'Lunglei', 'Mamit', 'Saiha', 'Serchhip'],
    'Nagaland': ['Dimapur', 'Kiphire', 'Kohima', 'Longleng', 'Mokokchung', 'Mon', 'Peren', 'Phek', 'Tuensang', 'Wokha', 'Zunheboto'],
    'Orissa': ['Angul', 'Balangir', 'Balasore', 'Bargarh', 'Bhadrak', 'Boudh', 'Cuttack', 'Deogarh', 'Dhenkanal', 'Gajapati', 'Ganjam', 'Jagatsinghapur', 'Jajpur', 'Jharsuguda', 'Kalahandi', 'Kandhamal', 'Kendrapara', 'Kendujhar (Keonjhar)', 'Khordha', 'Koraput', 'Malkangiri', 'Mayurbhanj', 'Nabarangpur', 'Nayagarh', 'Nuapada', 'Puri', 'Rayagada', 'Sambalpur', 'Sonepur', 'Sundargarh'],
    'Pondicherry': ['Karaikal', 'Mahe', 'Pondicherry', 'Yanam'],
    'Punjab': ['Amritsar', 'Barnala', 'Bathinda', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka', 'Ferozepur', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana', 'Mansa', 'Moga', 'Muktsar', 'Nawanshahr (Shahid Bhagat Singh Nagar)', 'Pathankot', 'Patiala', 'Rupnagar', 'Sahibzada Ajit Singh Nagar (Mohali)', 'Sangrur', 'Tarn Taran'],
    'Rajasthan': ['Ajmer', 'Alwar', 'Banswara', 'Baran', 'Barmer', 'Bharatpur', 'Bhilwara', 'Bikaner', 'Bundi', 'Chittorgarh', 'Churu', 'Dausa', 'Dholpur', 'Dungarpur', 'Hanumangarh', 'Jaipur', 'Jaisalmer', 'Jalore', 'Jhalawar', 'Jhunjhunu', 'Jodhpur', 'Karauli', 'Kota', 'Nagaur', 'Pali', 'Pratapgarh', 'Rajsamand', 'Sawai Madhopur', 'Sikar', 'Sirohi', 'Sri Ganganagar', 'Tonk', 'Udaipur'],
    'Sikkim': ['East Sikkim', 'North Sikkim', 'South Sikkim', 'West Sikkim'],
    'Tamil Nadu': ['Ariyalur', 'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri', 'Dindigul', 'Erode', 'Kanchipuram', 'Kanyakumari', 'Karur', 'Krishnagiri', 'Madurai', 'Nagapattinam', 'Namakkal', 'Nilgiris', 'Perambalur', 'Pudukkottai', 'Ramanathapuram', 'Salem', 'Sivaganga', 'Thanjavur', 'Theni', 'Thoothukudi (Tuticorin)', 'Tiruchirappalli', 'Tirunelveli', 'Tiruppur', 'Tiruvallur', 'Tiruvannamalai', 'Tiruvarur', 'Vellore', 'Viluppuram', 'Virudhunagar'],
    'Telangana': ['Adilabad', 'Bhadradri Kothagudem', 'Hyderabad', 'Jagtial', 'Jangaon', 'Jayashankar Bhoopalpally', 'Jogulamba Gadwal', 'Kamareddy', 'Karimnagar', 'Khammam', 'Komaram Bheem Asifabad', 'Mahabubabad', 'Mahabubnagar', 'Mancherial', 'Medak', 'Medchal', 'Nagarkurnool', 'Nalgonda', 'Nirmal', 'Nizamabad', 'Peddapalli', 'Rajanna Sircilla', 'Rangareddy', 'Sangareddy', 'Siddipet', 'Suryapet', 'Vikarabad', 'Wanaparthy', 'Warangal (Rural)', 'Warangal (Urban)', 'Yadadri Bhuvanagiri'],
    'Tripura': ['Dhalai', 'Gomati', 'Khowai', 'North Tripura', 'Sepahijala', 'South Tripura', 'Unakoti', 'West Tripura'],
    'Uttar Pradesh': ['Agra', 'Aligarh', 'Allahabad', 'Ambedkar Nagar', 'Amethi (Chatrapati Sahuji Mahraj Nagar)', 'Amroha (J.P. Nagar)', 'Auraiya', 'Azamgarh', 'Baghpat', 'Bahraich', 'Ballia', 'Balrampur', 'Banda', 'Barabanki', 'Bareilly', 'Basti', 'Bhadohi', 'Bijnor', 'Budaun', 'Bulandshahr', 'Chandauli', 'Chitrakoot', 'Deoria', 'Etah', 'Etawah', 'Faizabad', 'Farrukhabad', 'Fatehpur', 'Firozabad', 'Gautam Buddha Nagar', 'Ghaziabad', 'Ghazipur', 'Gonda', 'Gorakhpur', 'Hamirpur', 'Hapur (Panchsheel Nagar)', 'Hardoi', 'Hathras', 'Jalaun', 'Jaunpur', 'Jhansi', 'Kannauj', 'Kanpur Dehat', 'Kanpur Nagar', 'Kanshiram Nagar (Kasganj)', 'Kaushambi', 'Kushinagar (Padrauna)', 'Lakhimpur - Kheri', 'Lalitpur', 'Lucknow', 'Maharajganj', 'Mahoba', 'Mainpuri', 'Mathura', 'Mau', 'Meerut', 'Mirzapur', 'Moradabad', 'Muzaffarnagar', 'Pilibhit', 'Pratapgarh', 'RaeBareli', 'Rampur', 'Saharanpur', 'Sambhal (Bhim Nagar)', 'Sant Kabir Nagar', 'Shahjahanpur', 'Shamali (Prabuddh Nagar)', 'Shravasti', 'Siddharth Nagar', 'Sitapur', 'Sonbhadra', 'Sultanpur', 'Unnao', 'Varanasi'],
    'Uttarakhand': ['Almora', 'Bageshwar', 'Chamoli', 'Champawat', 'Dehradun', 'Haridwar', 'Nainital', 'Pauri Garhwal', 'Pithoragarh', 'Rudraprayag', 'Tehri Garhwal', 'Udham Singh Nagar', 'Uttarkashi'],
    'West Bengal': ['Alipurduar', 'Bankura', 'Birbhum', 'Burdwan (Bardhaman)', 'Cooch Behar', 'Dakshin Dinajpur (South Dinajpur)', 'Darjeeling', 'Hooghly', 'Howrah', 'Jalpaiguri', 'Kalimpong', 'Kolkata', 'Malda', 'Murshidabad', 'Nadia', 'North 24 Parganas', 'Paschim Medinipur (West Medinipur)', 'Purba Medinipur (East Medinipur)', 'Purulia', 'South 24 Parganas', 'Uttar Dinajpur (North Dinajpur)'],
  };

  /// Major cities per state (there's no single reliable public dataset
  /// mapping every one of India's ~700 districts to its cities, so this
  /// is scoped to state level — the same list is offered regardless of
  /// which district is picked within that state). Callers append their
  /// own 'Others' option — see [PartyController.cityOptions].
  static const Map<String, List<String>> citiesByState = {
    'Andaman And Nicobar Islands': ['Port Blair*'],
    'Andhra Pradesh': ['Adoni', 'Amalapuram', 'Anakapalle', 'Anantapur', 'Bapatla', 'Bheemunipatnam', 'Bhimavaram', 'Bobbili', 'Chilakaluripet', 'Chirala', 'Chittoor', 'Dharmavaram', 'Eluru', 'Gooty', 'Gudivada', 'Gudur', 'Guntakal', 'Guntur', 'Hindupur', 'Jaggaiahpet', 'Jammalamadugu', 'Kadapa', 'Kadiri', 'Kakinada', 'Kandukur', 'Kavali', 'Kovvur', 'Kurnool', 'Macherla', 'Machilipatnam', 'Madanapalle', 'Mandapeta', 'Markapur', 'Nagari', 'Naidupet', 'Nandyal', 'Narasapuram', 'Narasaraopet', 'Narsipatnam', 'Nellore', 'Nidadavole', 'Nuzvid', 'Ongole', 'Palacole', 'Palasa Kasibugga', 'Parvathipuram', 'Pedana', 'Peddapuram', 'Pithapuram', 'Ponnur', 'Proddatur', 'Punganur', 'Puttur', 'Rajahmundry', 'Rajam', 'Rajampet', 'Ramachandrapuram', 'Rayachoti', 'Rayadurg', 'Renigunta', 'Repalle', 'Salur', 'Samalkot', 'Sattenapalle', 'Srikakulam', 'Srikalahasti', 'Srisailam Project (Right Flank Colony) Township', 'Sullurpeta', 'Tadepalligudem', 'Tadpatri', 'Tanuku', 'Tenali', 'Tirupati', 'Tiruvuru', 'Tuni', 'Uravakonda', 'Venkatagiri', 'Vijayawada', 'Vinukonda', 'Visakhapatnam', 'Vizianagaram', 'Yemmiganur', 'Yerraguntla'],
    'Arunachal Pradesh': ['Naharlagun', 'Pasighat'],
    'Assam': ['Barpeta', 'Bongaigaon City', 'Dhubri', 'Dibrugarh', 'Diphu', 'Goalpara', 'Guwahati', 'Jorhat', 'Karimganj', 'Lanka', 'Lumding', 'Mangaldoi', 'Mankachar', 'Margherita', 'Mariani', 'Marigaon', 'Nagaon', 'Nalbari', 'North Lakhimpur', 'Rangia', 'Sibsagar', 'Silapathar', 'Silchar', 'Tezpur', 'Tinsukia'],
    'Bihar': ['Araria', 'Arrah', 'Arwal', 'Asarganj', 'Aurangabad', 'Bagaha', 'Barh', 'Begusarai', 'Bettiah', 'Bhabua', 'Bhagalpur', 'Buxar', 'Chhapra', 'Darbhanga', 'Dehri-on-Sone', 'Dumraon', 'Forbesganj', 'Gaya', 'Gopalganj', 'Hajipur', 'Jamalpur', 'Jamui', 'Jehanabad', 'Katihar', 'Kishanganj', 'Lakhisarai', 'Lalganj', 'Madhepura', 'Madhubani', 'Maharajganj', 'Mahnar Bazar', 'Makhdumpur', 'Maner', 'Manihari', 'Marhaura', 'Masaurhi', 'Mirganj', 'Mokameh', 'Motihari', 'Motipur', 'Munger', 'Murliganj', 'Muzaffarpur', 'Narkatiaganj', 'Naugachhia', 'Nawada', 'Nokha', 'Patna*', 'Piro', 'Purnia', 'Rafiganj', 'Rajgir', 'Ramnagar', 'Raxaul Bazar', 'Revelganj', 'Rosera', 'Saharsa', 'Samastipur', 'Sasaram', 'Sheikhpura', 'Sheohar', 'Sherghati', 'Silao', 'Sitamarhi', 'Siwan', 'Sonepur', 'Sugauli', 'Sultanganj', 'Supaul', 'Warisaliganj'],
    'Chandigarh': ['Chandigarh*'],
    'Chhattisgarh': ['Ambikapur', 'Bhatapara', 'Bhilai Nagar', 'Bilaspur', 'Chirmiri', 'Dalli-Rajhara', 'Dhamtari', 'Durg', 'Jagdalpur', 'Korba', 'Mahasamund', 'Manendragarh', 'Mungeli', 'Naila Janjgir', 'Raigarh', 'Raipur*', 'Rajnandgaon', 'Sakti', 'Tilda Newra'],
    'Dadra and Nagar Haveli': ['Silvassa*'],
    'Daman and Diu': ['Daman', 'Diu'],
    'Delhi': ['Delhi', 'New Delhi*'],
    'Goa': ['Mapusa', 'Margao', 'Marmagao', 'Panaji*'],
    'Gujarat': ['Adalaj', 'Ahmedabad', 'Amreli', 'Anand', 'Anjar', 'Ankleshwar', 'Bharuch', 'Bhavnagar', 'Bhuj', 'Chhapra', 'Deesa', 'Dhoraji', 'Godhra', 'Jamnagar', 'Kadi', 'Kapadvanj', 'Keshod', 'Khambhat', 'Lathi', 'Limbdi', 'Lunawada', 'Mahemdabad', 'Mahesana', 'Mahuva', 'Manavadar', 'Mandvi', 'Mangrol', 'Mansa', 'Modasa', 'Morvi', 'Nadiad', 'Navsari', 'Padra', 'Palanpur', 'Palitana', 'Pardi', 'Patan', 'Petlad', 'Porbandar', 'Radhanpur', 'Rajkot', 'Rajpipla', 'Rajula', 'Ranavav', 'Rapar', 'Salaya', 'Sanand', 'Savarkundla', 'Sidhpur', 'Sihor', 'Songadh', 'Surat', 'Talaja', 'Thangadh', 'Tharad', 'Umbergaon', 'Umreth', 'Una', 'Unjha', 'Upleta', 'Vadnagar', 'Vadodara', 'Valsad', 'Vapi', 'Veraval', 'Vijapur', 'Viramgam', 'Visnagar', 'Vyara', 'Wadhwan', 'Wankaner'],
    'Haryana': ['Bahadurgarh', 'Bhiwani', 'Charkhi Dadri', 'Faridabad', 'Fatehabad', 'Gohana', 'Gurgaon', 'Hansi', 'Hisar', 'Jind', 'Kaithal', 'Karnal', 'Ladwa', 'Mahendragarh', 'Mandi Dabwali', 'Narnaul', 'Narwana', 'Palwal', 'Panchkula', 'Panipat', 'Pehowa', 'Pinjore', 'Rania', 'Ratia', 'Rewari', 'Rohtak', 'Safidon', 'Samalkha', 'Sarsod', 'Shahbad', 'Sirsa', 'Sohna', 'Sonipat', 'Taraori', 'Thanesar', 'Tohana', 'Yamunanagar'],
    'Himachal Pradesh': ['Mandi', 'Nahan', 'Palampur', 'Shimla*', 'Solan', 'Sundarnagar'],
    'Jammu and Kashmir': ['Anantnag', 'Baramula', 'Jammu', 'Kathua', 'Punch', 'Rajauri', 'Sopore', 'Srinagar*', 'Udhampur'],
    'Jharkhand': ['Adityapur', 'Bokaro Steel City', 'Chaibasa', 'Chatra', 'Chirkunda', 'Deoghar', 'Dhanbad', 'Dumka', 'Giridih', 'Gumia', 'Hazaribag', 'Jamshedpur', 'Jhumri Tilaiya', 'Lohardaga', 'Madhupur', 'Medininagar (Daltonganj)', 'Mihijam', 'Musabani', 'Pakaur', 'Patratu', 'Phusro', 'Ramgarh', 'Ranchi*', 'Sahibganj', 'Saunda', 'Simdega', 'Tenu dam-cum-Kathhara'],
    'Karnataka': ['Adyar', 'Afzalpur', 'Arsikere', 'Athni', 'Ballari', 'Belagavi', 'Bengaluru', 'Chikkamagaluru', 'Davanagere', 'Gokak', 'Hubli-Dharwad', 'Karwar', 'Kolar', 'Lakshmeshwar', 'Lingsugur', 'Maddur', 'Madhugiri', 'Madikeri', 'Magadi', 'Mahalingapura', 'Malavalli', 'Malur', 'Mandya', 'Mangaluru', 'Manvi', 'Mudabidri', 'Mudalagi', 'Muddebihal', 'Mudhol', 'Mulbagal', 'Mundargi', 'Nanjangud', 'Nargund', 'Navalgund', 'Nelamangala', 'Pavagada', 'Piriyapatna', 'Puttur', 'Raayachuru', 'Rabkavi Banhatti', 'Ramanagaram', 'Ramdurg', 'Ranebennuru', 'Ranibennur', 'Robertson Pet', 'Ron', 'Sadalagi', 'Sagara', 'Sakaleshapura', 'Sanduru', 'Sankeshwara', 'Saundatti-Yellamma', 'Savanur', 'Sedam', 'Shahabad', 'Shahpur', 'Shiggaon', 'Shikaripur', 'Shivamogga', 'Shrirangapattana', 'Sidlaghatta', 'Sindagi', 'Sindhagi', 'Sindhnur', 'Sira', 'Sirsi', 'Siruguppa', 'Srinivaspur', 'Surapura', 'Talikota', 'Tarikere', 'Tekkalakote', 'Terdal', 'Tiptur', 'Tumkur', 'Udupi', 'Vijayapura', 'Wadi', 'Yadgir'],
    'Kerala': ['Adoor', 'Alappuzha', 'Attingal', 'Chalakudy', 'Changanassery', 'Cherthala', 'Chittur-Thathamangalam', 'Guruvayoor', 'Kanhangad', 'Kannur', 'Kasaragod', 'Kayamkulam', 'Kochi', 'Kodungallur', 'Kollam', 'Kottayam', 'Koyilandy', 'Kozhikode', 'Kunnamkulam', 'Malappuram', 'Mattannur', 'Mavelikkara', 'Mavoor', 'Muvattupuzha', 'Nedumangad', 'Neyyattinkara', 'Nilambur', 'Ottappalam', 'Palai', 'Palakkad', 'Panamattom', 'Panniyannur', 'Pappinisseri', 'Paravoor', 'Pathanamthitta', 'Peringathur', 'Perinthalmanna', 'Perumbavoor', 'Ponnani', 'Punalur', 'Puthuppally', 'Shoranur', 'Taliparamba', 'Thiruvalla', 'Thiruvananthapuram', 'Thodupuzha', 'Thrissur', 'Tirur', 'Vaikom', 'Varkala', 'Vatakara'],
    'Ladakh': ['Kargil', 'Leh'],
    'Lakshadweep': ['Kavaratti'],
    'Madhya Pradesh': ['Alirajpur', 'Ashok Nagar', 'Balaghat', 'Bhopal', 'Ganjbasoda', 'Gwalior', 'Indore', 'Itarsi', 'Jabalpur', 'Lahar', 'Maharajpur', 'Mahidpur', 'Maihar', 'Malaj Khand', 'Manasa', 'Manawar', 'Mandideep', 'Mandla', 'Mandsaur', 'Mauganj', 'Mhow Cantonment', 'Mhowgaon', 'Morena', 'Multai', 'Mundi', 'Murwara (Katni)', 'Nagda', 'Nainpur', 'Narsinghgarh', 'Neemuch', 'Nepanagar', 'Niwari', 'Nowgong', 'Nowrozabad (Khodargama)', 'Pachore', 'Pali', 'Panagar', 'Pandhurna', 'Panna', 'Pasan', 'Pipariya', 'Pithampur', 'Porsa', 'Prithvipur', 'Raghogarh-Vijaypur', 'Rahatgarh', 'Raisen', 'Rajgarh', 'Ratlam', 'Rau', 'Rehli', 'Rewa', 'Sabalgarh', 'Sagar', 'Sanawad', 'Sarangpur', 'Sarni', 'Satna', 'Sausar', 'Sehore', 'Sendhwa', 'Seoni', 'Seoni-Malwa', 'Shahdol', 'Shajapur', 'Shamgarh', 'Sheopur', 'Shivpuri', 'Shujalpur', 'Sidhi', 'Sihora', 'Singrauli', 'Sironj', 'Sohagpur', 'Tarana', 'Tikamgarh', 'Ujjain', 'Umaria', 'Vidisha', 'Vijaypur', 'Wara Seoni'],
    'Maharashtra': ['Ahmednagar', 'Akola', 'Akot', 'Amalner', 'Ambejogai', 'Amravati', 'Anjangaon', 'Arvi', 'Aurangabad', 'Bhiwandi', 'Dhule', 'Greater Mumbai*', 'Ichalkaranji', 'Kalyan-Dombivali', 'Karjat', 'Latur', 'Loha', 'Lonar', 'Lonavla', 'Mahad', 'Malegaon', 'Malkapur', 'Mangalvedhe', 'Mangrulpir', 'Manjlegaon', 'Manmad', 'Manwath', 'Mehkar', 'Mhaswad', 'Mira-Bhayandar', 'Morshi', 'Mukhed', 'Mul', 'Murtijapur', 'Nagpur', 'Nanded-Waghala', 'Nandgaon', 'Nandura', 'Nandurbar', 'Narkhed', 'Nashik', 'Navi Mumbai', 'Nawapur', 'Nilanga', 'Osmanabad', 'Ozar', 'Pachora', 'Paithan', 'Palghar', 'Pandharkaoda', 'Pandharpur', 'Panvel', 'Parbhani', 'Parli', 'Partur', 'Pathardi', 'Pathri', 'Patur', 'Pauni', 'Pen', 'Phaltan', 'Pulgaon', 'Pune', 'Purna', 'Pusad', 'Rahuri', 'Rajura', 'Ramtek', 'Ratnagiri', 'Raver', 'Risod', 'Sailu', 'Sangamner', 'Sangli', 'Sangole', 'Sasvad', 'Satana', 'Satara', 'Savner', 'Sawantwadi', 'Shahade', 'Shegaon', 'Shendurjana', 'Shirdi', 'Shirpur-Warwade', 'Shirur', 'Shrigonda', 'Shrirampur', 'Sillod', 'Sinnar', 'Solapur', 'Soyagaon', 'Talegaon Dabhade', 'Talode', 'Tasgaon', 'Thane', 'Tirora', 'Tuljapur', 'Tumsar', 'Uchgaon', 'Udgir', 'Umarga', 'Umarkhed', 'Umred', 'Uran', 'Uran Islampur', 'Vadgaon Kasba', 'Vaijapur', 'Vasai-Virar', 'Vita', 'Wadgaon Road', 'Wai', 'Wani', 'Wardha', 'Warora', 'Warud', 'Washim', 'Yavatmal', 'Yawal', 'Yevla'],
    'Manipur': ['Imphal*', 'Lilong', 'Mayang Imphal', 'Thoubal'],
    'Meghalaya': ['Nongstoin', 'Shillong*', 'Tura'],
    'Mizoram': ['Aizawl', 'Lunglei', 'Saiha'],
    'Nagaland': ['Dimapur', 'Kohima*', 'Mokokchung', 'Tuensang', 'Wokha', 'Zunheboto'],
    'Orissa': ['Balangir', 'Baleshwar Town', 'Barbil', 'Bargarh', 'Baripada Town', 'Bhadrak', 'Bhawanipatna', 'Bhubaneswar*', 'Brahmapur', 'Byasanagar', 'Cuttack', 'Dhenkanal', 'Jatani', 'Jharsuguda', 'Kendrapara', 'Kendujhar', 'Malkangiri', 'Nabarangapur', 'Paradip', 'Parlakhemundi', 'Pattamundai', 'Phulabani', 'Puri', 'Rairangpur', 'Rajagangapur', 'Raurkela', 'Rayagada', 'Sambalpur', 'Soro', 'Sunabeda', 'Sundargarh', 'Talcher', 'Tarbha', 'Titlagarh'],
    'Pondicherry': ['Karaikal', 'Mahe', 'Pondicherry*', 'Yanam'],
    'Punjab': ['Amritsar', 'Barnala', 'Batala', 'Bathinda', 'Dhuri', 'Faridkot', 'Fazilka', 'Firozpur', 'Firozpur Cantt.', 'Gobindgarh', 'Gurdaspur', 'Hoshiarpur', 'Jagraon', 'Jalandhar', 'Jalandhar Cantt.', 'Kapurthala', 'Khanna', 'Kharar', 'Kot Kapura', 'Longowal', 'Ludhiana', 'Malerkotla', 'Malout', 'Mansa', 'Moga', 'Mohali', 'Morinda, India', 'Mukerian', 'Muktsar', 'Nabha', 'Nakodar', 'Nangal', 'Nawanshahr', 'Pathankot', 'Patiala', 'Patti', 'Pattran', 'Phagwara', 'Phillaur', 'Qadian', 'Raikot', 'Rajpura', 'Rampura Phul', 'Rupnagar', 'Samana', 'Sangrur', 'Sirhind Fatehgarh Sahib', 'Sujanpur', 'Sunam', 'Talwara', 'Tarn Taran', 'Urmar Tanda', 'Zira', 'Zirakpur'],
    'Rajasthan': ['Ajmer', 'Alwar', 'Bharatpur', 'Bhilwara', 'Bikaner', 'Jaipur*', 'Jodhpur', 'Lachhmangarh', 'Ladnu', 'Lakheri', 'Lalsot', 'Losal', 'Makrana', 'Malpura', 'Mandalgarh', 'Mandawa', 'Mangrol', 'Merta City', 'Mount Abu', 'Nadbai', 'Nagar', 'Nagaur', 'Nasirabad', 'Nathdwara', 'Neem-Ka-Thana', 'Nimbahera', 'Nohar', 'Nokha', 'Pali', 'Phalodi', 'Phulera', 'Pilani', 'Pilibanga', 'Pindwara', 'Pipar City', 'Prantij', 'Pratapgarh', 'Raisinghnagar', 'Rajakhera', 'Rajaldesar', 'Rajgarh (Alwar)', 'Rajgarh (Churu)', 'Rajsamand', 'Ramganj Mandi', 'Ramngarh', 'Ratangarh', 'Rawatbhata', 'Rawatsar', 'Reengus', 'Sadri', 'Sadulpur', 'Sadulshahar', 'Sagwara', 'Sambhar', 'Sanchore', 'Sangaria', 'Sardarshahar', 'Sawai Madhopur', 'Shahpura', 'Sheoganj', 'Sikar', 'Sirohi', 'Sojat', 'Sri Madhopur', 'Sujangarh', 'Sumerpur', 'Suratgarh', 'Taranagar', 'Todabhim', 'Todaraisingh', 'Tonk', 'Udaipur', 'Udaipurwati', 'Vijainagar, Ajmer'],
    'Sikkim': ['Gangtok', 'Gyalshing', 'Mangan', 'Namchi'],
    'Tamil Nadu': ['Arakkonam', 'Aruppukkottai', 'Chennai*', 'Coimbatore', 'Erode', 'Gobichettipalayam', 'Kancheepuram', 'Karur', 'Lalgudi', 'Madurai', 'Manachanallur', 'Nagapattinam', 'Nagercoil', 'Namagiripettai', 'Namakkal', 'Nandivaram-Guduvancheri', 'Nanjikottai', 'Natham', 'Nellikuppam', 'Neyveli (TS)', 'O\' Valley', 'Oddanchatram', 'P.N.Patti', 'Pacode', 'Padmanabhapuram', 'Palani', 'Palladam', 'Pallapatti', 'Pallikonda', 'Panagudi', 'Panruti', 'Paramakudi', 'Parangipettai', 'Pattukkottai', 'Perambalur', 'Peravurani', 'Periyakulam', 'Periyasemur', 'Pernampattu', 'Pollachi', 'Polur', 'Ponneri', 'Pudukkottai', 'Pudupattinam', 'Puliyankudi', 'Punjaipugalur', 'Rajapalayam', 'Ramanathapuram', 'Rameshwaram', 'Ranipet', 'Rasipuram', 'Salem', 'Sankarankoil', 'Sankari', 'Sathyamangalam', 'Sattur', 'Shenkottai', 'Sholavandan', 'Sholingur', 'Sirkali', 'Sivaganga', 'Sivagiri', 'Sivakasi', 'Srivilliputhur', 'Surandai', 'Suriyampalayam', 'Tenkasi', 'Thammampatti', 'Thanjavur', 'Tharamangalam', 'Tharangambadi', 'Theni Allinagaram', 'Thirumangalam', 'Thirupuvanam', 'Thiruthuraipoondi', 'Thiruvallur', 'Thiruvarur', 'Thuraiyur', 'Tindivanam', 'Tiruchendur', 'Tiruchengode', 'Tiruchirappalli', 'Tirukalukundram', 'Tirukkoyilur', 'Tirunelveli', 'Tirupathur', 'Tiruppur', 'Tiruttani', 'Tiruvannamalai', 'Tiruvethipuram', 'Tittakudi', 'Udhagamandalam', 'Udumalaipettai', 'Unnamalaikadai', 'Usilampatti', 'Uthamapalayam', 'Uthiramerur', 'Vadakkuvalliyur', 'Vadalur', 'Vadipatti', 'Valparai', 'Vandavasi', 'Vaniyambadi', 'Vedaranyam', 'Vellakoil', 'Vellore', 'Vikramasingapuram', 'Viluppuram', 'Virudhachalam', 'Virudhunagar', 'Viswanatham'],
    'Telangana': ['Adilabad', 'Bellampalle', 'Bhadrachalam', 'Bhainsa', 'Bhongir', 'Bodhan', 'Farooqnagar', 'Gadwal', 'Hyderabad*', 'Jagtial', 'Jangaon', 'Kagaznagar', 'Kamareddy', 'Karimnagar', 'Khammam', 'Koratla', 'Kothagudem', 'Kyathampalle', 'Mahbubnagar', 'Mancherial', 'Mandamarri', 'Manuguru', 'Medak', 'Miryalaguda', 'Nagarkurnool', 'Narayanpet', 'Nirmal', 'Nizamabad', 'Palwancha', 'Ramagundam', 'Sadasivpet', 'Sangareddy', 'Siddipet', 'Sircilla', 'Suryapet', 'Tandur', 'Vikarabad', 'Wanaparthy', 'Warangal', 'Yellandu'],
    'Tripura': ['Agartala*', 'Belonia', 'Dharmanagar', 'Kailasahar', 'Khowai', 'Pratapgarh', 'Udaipur'],
    'Uttar Pradesh': ['Achhnera', 'Agra', 'Aligarh', 'Allahabad', 'Amroha', 'Azamgarh', 'Bahraich', 'Chandausi', 'Etawah', 'Fatehpur Sikri', 'Firozabad', 'Hapur', 'Hardoi *', 'Jhansi', 'Kalpi', 'Kanpur', 'Khair', 'Laharpur', 'Lakhimpur', 'Lal Gopalganj Nindaura', 'Lalganj', 'Lalitpur', 'Lar', 'Loni', 'Lucknow*', 'Mathura', 'Meerut', 'Modinagar', 'Moradabad', 'Nagina', 'Najibabad', 'Nakur', 'Nanpara', 'Naraura', 'Naugawan Sadat', 'Nautanwa', 'Nawabganj', 'Nehtaur', 'Niwai', 'Noida', 'Noorpur', 'Obra', 'Orai', 'Padrauna', 'Palia Kalan', 'Parasi', 'Phulpur', 'Pihani', 'Pilibhit', 'Pilkhuwa', 'Powayan', 'Pukhrayan', 'Puranpur', 'Purquazi', 'Purwa', 'Rae Bareli', 'Rampur', 'Rampur Maniharan', 'Rasra', 'Rath', 'Renukoot', 'Reoti', 'Robertsganj', 'Rudauli', 'Rudrapur', 'Sadabad', 'Safipur', 'Saharanpur', 'Sahaspur', 'Sahaswan', 'Sahawar', 'Sahjanwa', 'Saidpur', 'Sambhal', 'Samdhan', 'Samthar', 'Sandi', 'Sandila', 'Sardhana', 'Seohara', 'Shahabad, Hardoi', 'Shahabad, Rampur', 'Shahganj', 'Shahjahanpur', 'Shamli', 'Shamsabad, Agra', 'Shamsabad, Farrukhabad', 'Sherkot', 'Shikarpur, Bulandshahr', 'Shikohabad', 'Shishgarh', 'Siana', 'Sikanderpur', 'Sikandra Rao', 'Sikandrabad', 'Sirsaganj', 'Sirsi', 'Sitapur', 'Soron', 'Suar', 'Sultanpur', 'Sumerpur', 'Tanda', 'Thakurdwara', 'Thana Bhawan', 'Tilhar', 'Tirwaganj', 'Tulsipur', 'Tundla', 'Ujhani', 'Unnao', 'Utraula', 'Varanasi', 'Vrindavan', 'Warhapur', 'Zaidpur', 'Zamania'],
    'Uttarakhand': ['Bageshwar', 'Dehradun', 'Haldwani-cum-Kathgodam', 'Hardwar', 'Kashipur', 'Manglaur', 'Mussoorie', 'Nagla', 'Nainital', 'Pauri', 'Pithoragarh', 'Ramnagar', 'Rishikesh', 'Roorkee', 'Rudrapur', 'Sitarganj', 'Srinagar', 'Tehri'],
    'West Bengal': ['Adra', 'Alipurduar', 'Arambagh', 'Asansol', 'Baharampur', 'Balurghat', 'Bankura', 'Darjiling', 'English Bazar', 'Gangarampur', 'Habra', 'Hugli-Chinsurah', 'Jalpaiguri', 'Jhargram', 'Kalimpong', 'Kharagpur', 'Kolkata', 'Mainaguri', 'Malda', 'Mathabhanga', 'Medinipur', 'Memari', 'Monoharpur', 'Murshidabad', 'Nabadwip', 'Naihati', 'Panchla', 'Pandua', 'Paschim Punropara', 'Purulia', 'Raghunathganj', 'Raghunathpur', 'Raiganj', 'Rampurhat', 'Ranaghat', 'Sainthia', 'Santipur', 'Siliguri', 'Sonamukhi', 'Srirampore', 'Suri', 'Taki', 'Tamluk', 'Tarakeswar'],
  };

  static List<PartyModel> parties() => [
        PartyModel(
          id: 'P001',
          name: 'VEERAPANDIAN - 9940382132',
          phone: '9940382132',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 12500,
        ),
        PartyModel(
          id: 'P002',
          name: 'NIYAA CRACKERS WORLD',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 0,
        ),
        PartyModel(
          id: 'P003',
          name: 'RAJASEKAR',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 4500,
        ),
        PartyModel(
          id: 'P004',
          name: 'Akshaya Traders Sivakasi',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 3200,
        ),
        PartyModel(
          id: 'P005',
          name: 'RAJASEGARAN',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 0,
        ),
        PartyModel(
          id: 'P006',
          name: 'SASI TAPES - 9952567397',
          phone: '9952567397',
          agent: 'Mahendran',
          state: 'Tamil Nadu',
          district: 'Madurai',
          city: 'Madurai',
          openingBalance: 875,
        ),
        PartyModel(
          id: 'P007',
          name: 'SHANMUGAM - 8870106383',
          phone: '8870106383',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 0,
        ),
        PartyModel(
          id: 'P008',
          name: 'PALANI',
          state: 'Tamil Nadu',
          district: 'Tirunelveli',
          city: 'Tirunelveli',
          openingBalance: 0,
          balanceType: BalanceType.debit,
        ),
        PartyModel(
          id: 'P009',
          name: 'MURUGAN KUIL FIRE WORKS',
          agent: 'Karthik',
          state: 'Tamil Nadu',
          district: 'Virudhunagar',
          city: 'Sivakasi',
          openingBalance: 45000,
        ),
        PartyModel(
          id: 'P010',
          name: 'KISHORE - 8220258027',
          phone: '8220258027',
          state: 'Tamil Nadu',
          district: 'Sivagangai',
          city: 'Karaikudi',
          openingBalance: 0,
        ),
      ];

  /// Dropdown master data for the Product screens.
  static const List<String> productCategories = [
    'NIGHT COMMETS - MB',
    'CERMONIAL COLOUR NIGHT - MB',
    'SVA GIFTBOX',
    'SPARKLERS',
    'AERIAL',
    'ROCKETS',
  ];

  static const List<String> productUnits = ['BOX', 'ITEM', 'PCS', 'PACK'];

  static const List<String> pricelists = [
    'MB JUNE RETAIL SALE PRICE LIST',
    'MB WHOLESALE PRICE LIST',
    'SEASON OPENING PRICE LIST',
  ];

  static List<ProductModel> products() => [
        ProductModel(
          id: 'PR001',
          category: 'NIGHT COMMETS - MB',
          code: '',
          name: '6" SINGLE SUPER HEROES SERIES (EXCLUSIVE)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: 0,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 1226),
          ],
        ),
        ProductModel(
          id: 'PR002',
          category: 'CERMONIAL COLOUR NIGHT - MB',
          code: '',
          name: 'GRAND OPENING 5*10 CRACKLING MULTI COLOUR SHOTS',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: 0,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 2450),
          ],
        ),
        ProductModel(
          id: 'PR003',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'NATCHIYAR (45 Item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -4,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 3200),
          ],
        ),
        ProductModel(
          id: 'PR004',
          category: 'SVA GIFTBOX',
          code: '',
          name: '7 HILLS (41 Item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 2890),
          ],
        ),
        ProductModel(
          id: 'PR005',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'GANESH (36 item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 2540),
          ],
        ),
        ProductModel(
          id: 'PR006',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'SKYTOWER (33 item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 2310),
          ],
        ),
        ProductModel(
          id: 'PR007',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'SILVER (30 Item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 2100),
          ],
        ),
        ProductModel(
          id: 'PR008',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'GOLD (27 Item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 1890),
          ],
        ),
        ProductModel(
          id: 'PR009',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'FUNLAND (24 Item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 1650),
          ],
        ),
        ProductModel(
          id: 'PR010',
          category: 'SVA GIFTBOX',
          code: '',
          name: 'DIAMOND (21 Item)',
          unit: 'BOX',
          stockMaintain: true,
          negativeStock: true,
          currentStock: -3,
          prices: [
            PricelistEntry(
                pricelistName: 'MB JUNE RETAIL SALE PRICE LIST', price: 1420),
          ],
        ),
      ];

  static List<QuotationModel> quotations() {
    final prods = products();
    return [
      QuotationModel(
        id: 'Q001',
        quotationNo: 'QUT001/26-27',
        partyId: 'P001',
        partyName: 'Sri Lakshmi Traders',
        pricelistName: 'MB JUNE RETAIL SALE PRICE LIST',
        date: DateTime(2026, 7, 1),
        items: [
          BillingItemModel(
              productId: prods[0].id,
              productName: prods[0].name,
              quantity: 20,
              rate: prods[0].price,
              unit: prods[0].unit),
          BillingItemModel(
              productId: prods[2].id,
              productName: prods[2].name,
              quantity: 5,
              rate: prods[2].price,
              discountPercent: 5,
              unit: prods[2].unit),
        ],
        status: DocStatus.active,
      ),
      QuotationModel(
        id: 'Q002',
        quotationNo: 'QUT002/26-27',
        partyId: 'P006',
        partyName: 'THARUN',
        pricelistName: 'MB JUNE RETAIL SALE PRICE LIST',
        date: DateTime(2026, 6, 1),
        items: [
          BillingItemModel(
              productId: prods[6].id,
              productName: prods[6].name,
              quantity: 10,
              rate: prods[6].price,
              unit: prods[6].unit),
        ],
        status: DocStatus.active,
      ),
      QuotationModel(
        id: 'Q003',
        quotationNo: 'QUT003/26-27',
        partyId: 'P006',
        partyName: 'Anbu & Sons',
        pricelistName: 'MB JUNE RETAIL SALE PRICE LIST',
        date: DateTime(2026, 6, 28),
        items: [
          BillingItemModel(
              productId: prods[4].id,
              productName: prods[4].name,
              quantity: 30,
              rate: prods[4].price,
              unit: prods[4].unit),
          BillingItemModel(
              productId: prods[7].id,
              productName: prods[7].name,
              quantity: 100,
              rate: prods[7].price,
              unit: prods[7].unit),
        ],
        status: DocStatus.draft,
      ),
      QuotationModel(
        id: 'Q004',
        quotationNo: 'QUT004/26-27',
        partyId: 'P002',
        partyName: 'Kaveri Crackers Wholesale',
        pricelistName: 'MB JUNE RETAIL SALE PRICE LIST',
        date: DateTime(2026, 6, 20),
        items: [
          BillingItemModel(
              productId: prods[1].id,
              productName: prods[1].name,
              quantity: 40,
              rate: prods[1].price,
              unit: prods[1].unit),
        ],
        status: DocStatus.cancelled,
      ),
    ];
  }

  static List<EstimationModel> estimations() {
    final prods = products();
    return [
      EstimationModel(
        id: 'E001',
        estimationNo: 'EST037/26-27',
        partyId: 'P002',
        partyName: 'Kaveri Crackers Wholesale',
        pricelistName: '2026 MB June Whole Sale Price',
        date: DateTime(2026, 7, 6),
        items: [
          BillingItemModel(
              productId: prods[3].id,
              productName: prods[3].name,
              quantity: 6,
              rate: 1400,
              unit: 'BOX'),
        ],
        status: DocStatus.active,
      ),
      EstimationModel(
        id: 'E002',
        estimationNo: 'EST036/26-27',
        partyId: 'P001',
        partyName: 'Sri Lakshmi Traders',
        pricelistName: '2026 MB June Whole Sale Price',
        date: DateTime(2026, 7, 4),
        items: [
          BillingItemModel(
              productId: prods[6].id,
              productName: prods[6].name,
              quantity: 8,
              rate: prods[6].price),
        ],
        status: DocStatus.active,
      ),
      EstimationModel(
        id: 'E003',
        estimationNo: 'EST035/26-27',
        partyId: 'P006',
        partyName: 'Anbu & Sons',
        pricelistName: '2026 MB June Whole Sale Price',
        date: DateTime(2026, 6, 30),
        items: [
          BillingItemModel(
              productId: prods[0].id,
              productName: prods[0].name,
              quantity: 15,
              rate: prods[0].price),
          BillingItemModel(
              productId: prods[2].id,
              productName: prods[2].name,
              quantity: 3,
              rate: prods[2].price,
              section: 2),
        ],
        status: DocStatus.active,
      ),
      EstimationModel(
        id: 'E004',
        estimationNo: 'EST034/26-27',
        partyId: 'P003',
        partyName: 'Meenakshi Fireworks',
        pricelistName: '2026 MB June Whole Sale Price',
        date: DateTime(2026, 6, 28),
        items: [
          BillingItemModel(
              productId: prods[4].id,
              productName: prods[4].name,
              quantity: 20,
              rate: prods[4].price),
        ],
        status: DocStatus.draft,
      ),
      EstimationModel(
        id: 'E005',
        estimationNo: 'EST033/26-27',
        partyId: 'P004',
        partyName: 'Vinayaga Traders',
        pricelistName: '2026 MB June Whole Sale Price',
        date: DateTime(2026, 6, 25),
        items: [
          BillingItemModel(
              productId: prods[1].id,
              productName: prods[1].name,
              quantity: 10,
              rate: prods[1].price),
        ],
        status: DocStatus.draft,
      ),
      EstimationModel(
        id: 'E006',
        estimationNo: 'EST032/26-27',
        partyId: 'P005',
        partyName: 'Om Sakthi Crackers',
        pricelistName: '2026 MB June Whole Sale Price',
        date: DateTime(2026, 6, 20),
        items: [
          BillingItemModel(
              productId: prods[5].id,
              productName: prods[5].name,
              quantity: 5,
              rate: prods[5].price),
        ],
        status: DocStatus.cancelled,
      ),
    ];
  }

  static List<StockAdjustmentModel> stockAdjustments() {
    final prods = products();
    return [
      StockAdjustmentModel(
        id: 'SA004',
        billNo: '',
        date: DateTime(2026, 7, 8),
        remarks: 'Checking 2',
        items: [
          StockAdjustmentItem(
            productId: prods[1].id,
            productName: prods[1].name,
            unit: prods[1].unit,
            qty: 2,
            action: StockAction.remove,
          ),
        ],
        status: DocStatus.draft,
      ),
      StockAdjustmentModel(
        id: 'SA001',
        billNo: 'STA011/26-27',
        date: DateTime(2026, 7, 8),
        remarks: 'checking',
        items: [
          StockAdjustmentItem(
            productId: prods[0].id,
            productName: prods[0].name,
            unit: prods[0].unit,
            qty: 1,
            action: StockAction.add,
          ),
          StockAdjustmentItem(
            productId: prods[1].id,
            productName: prods[1].name,
            unit: prods[1].unit,
            qty: 1,
            action: StockAction.remove,
          ),
        ],
        status: DocStatus.active,
      ),
      StockAdjustmentModel(
        id: 'SA002',
        billNo: 'STA010/26-27',
        date: DateTime(2026, 7, 3),
        remarks: 'New purchase from Standard Fireworks',
        items: [
          StockAdjustmentItem(
            productId: prods[2].id,
            productName: prods[2].name,
            unit: prods[2].unit,
            qty: 50,
            action: StockAction.add,
          ),
        ],
        status: DocStatus.active,
      ),
      StockAdjustmentModel(
        id: 'SA003',
        billNo: 'STA009/26-27',
        date: DateTime(2026, 7, 1),
        remarks: 'Water damage in godown',
        items: [
          StockAdjustmentItem(
            productId: prods[5].id,
            productName: prods[5].name,
            unit: prods[5].unit,
            qty: 4,
            action: StockAction.remove,
          ),
        ],
        status: DocStatus.cancelled,
      ),
    ];
  }
}
