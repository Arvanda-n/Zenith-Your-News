import '../models/news_item.dart';

NewsItem _newsItem({
  required String id,
  required String title,
  required String description,
  required String content,
  required String category,
  required DateTime date,
  required int readMinutes,
  required String imageHint,
  required String imageUrl,
  bool featured = false,
  int trendingScore = 0,
}) {
  return NewsItem(
    id: id,
    title: title,
    description: description,
    content: content,
    category: category,
    date: date,
    readMinutes: readMinutes,
    imageHint: imageHint,
    imageUrl: imageUrl,
    featured: featured,
    trendingScore: trendingScore,
  );
}

final List<NewsItem> dummyNews = <NewsItem>[
  _newsItem(
    id: 'n1',
    title: 'AI Bantu Produktivitas Tim Jarak Jauh Meningkat 2x Lipat',
    description:
        'Perusahaan teknologi melaporkan kenaikan produktivitas setelah adopsi AI assistant.',
    content:
        'Adopsi alat berbasis AI dalam workflow harian menunjukkan dampak signifikan pada kecepatan kerja. Tim dapat merangkum rapat, menyusun draf dokumen, dan mengotomatiskan tugas repetitif dengan lebih efisien. Para analis menilai tren ini akan terus tumbuh dalam dua tahun ke depan.',
    category: 'Teknologi',
    date: DateTime(2026, 5, 4),
    readMinutes: 6,
    imageHint: 'AI Office',
    imageUrl:
        'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80',
    featured: true,
    trendingScore: 98,
  ),
  _newsItem(
    id: 'n2',
    title: 'Pusat Data Hijau Jakarta Diuji Coba untuk Startup AI Lokal',
    description:
        'Operator cloud menyiapkan pusat data hemat energi bagi perusahaan rintisan domestik.',
    content:
        'Pusat data generasi baru ini mengandalkan pendinginan efisien dan pemantauan beban real-time agar biaya operasional tetap terkendali. Startup lokal menyebut infrastruktur tersebut membantu mereka mempercepat eksperimen produk tanpa menaikkan ongkos komputasi secara tajam.',
    category: 'Teknologi',
    date: DateTime(2026, 5, 3),
    readMinutes: 5,
    imageHint: 'Data Center',
    imageUrl:
        'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 95,
  ),
  _newsItem(
    id: 'n3',
    title: 'Dompet Digital Tambah Fitur Proteksi Penipuan Berbasis Perilaku',
    description:
        'Sistem baru mendeteksi pola transaksi janggal sebelum pembayaran diselesaikan.',
    content:
        'Dengan analisis perilaku dan perangkat, layanan pembayaran digital kini bisa memberi peringatan dini ketika aktivitas pengguna terindikasi berisiko. Sejumlah bank melihat pendekatan ini efektif menekan keluhan pembobolan akun pada fase uji coba awal.',
    category: 'Teknologi',
    date: DateTime(2026, 5, 2),
    readMinutes: 4,
    imageHint: 'Digital Wallet',
    imageUrl:
        'https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 91,
  ),
  _newsItem(
    id: 'n4',
    title: 'Produsen Ponsel Lokal Fokus pada Kamera Malam dan Daya Tahan',
    description:
        'Pabrikan nasional menargetkan pengguna muda yang aktif membuat konten mobile.',
    content:
        'Seri baru ini mengunggulkan optimasi kamera malam, baterai besar, dan pemrosesan foto berbasis AI untuk kelas menengah. Distributor menilai strategi fitur praktis lebih relevan dibanding sekadar perang spesifikasi di pasar yang makin padat.',
    category: 'Teknologi',
    date: DateTime(2026, 5, 1),
    readMinutes: 5,
    imageHint: 'Smartphone Camera',
    imageUrl:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 88,
  ),
  _newsItem(
    id: 'n5',
    title: 'Kampus Bandung Luncurkan Laboratorium Robotika Terbuka untuk UMKM',
    description:
        'Pelaku usaha kini bisa menguji otomatisasi sederhana tanpa investasi alat besar.',
    content:
        'Laboratorium ini menyediakan akses terbatas pada lengan robot, sensor, dan mentor teknis untuk membantu UMKM memahami proses otomasi. Pengelola berharap skema tersebut mendorong adopsi teknologi manufaktur yang lebih realistis di luar industri besar.',
    category: 'Teknologi',
    date: DateTime(2026, 4, 30),
    readMinutes: 6,
    imageHint: 'Robotics Lab',
    imageUrl:
        'https://images.unsplash.com/photo-1535378917042-10a22c95931a?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 84,
  ),
  _newsItem(
    id: 'n6',
    title: 'Ekonomi Hijau Dorong Investasi Baru di Asia Tenggara',
    description:
        'Nilai investasi proyek energi bersih meningkat tajam pada kuartal pertama 2026.',
    content:
        'Investasi pada energi surya, angin, dan kendaraan listrik meningkat berkat kebijakan fiskal baru. Pemerintah dan swasta berkolaborasi membangun infrastruktur yang lebih ramah lingkungan. Dampaknya diprediksi menciptakan lapangan kerja baru secara luas.',
    category: 'Ekonomi',
    date: DateTime(2026, 4, 29),
    readMinutes: 5,
    imageHint: 'Green Energy',
    imageUrl:
        'https://images.unsplash.com/photo-1466611653911-95081537e5b7?auto=format&fit=crop&w=1200&q=80',
    featured: true,
    trendingScore: 96,
  ),
  _newsItem(
    id: 'n7',
    title: 'Belanja Ramadan Digital Tahun Ini Dongkrak Omzet UMKM Daerah',
    description:
        'Pelaku usaha kecil mencatat lonjakan transaksi melalui live commerce dan marketplace.',
    content:
        'Peningkatan pembelian terjadi karena UMKM mulai konsisten memanfaatkan promosi bundel, siaran langsung, dan logistik instan. Pengamat ekonomi melihat pola ini menandai kematangan kanal digital bagi bisnis yang sebelumnya hanya mengandalkan penjualan offline.',
    category: 'Ekonomi',
    date: DateTime(2026, 4, 28),
    readMinutes: 4,
    imageHint: 'Online Shopping',
    imageUrl:
        'https://images.unsplash.com/photo-1556740749-887f6717d7e4?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 93,
  ),
  _newsItem(
    id: 'n8',
    title: 'Harga Pangan Mulai Stabil Setelah Distribusi Antarpulau Dipercepat',
    description:
        'Perbaikan rantai pasok membuat selisih harga bahan pokok antarwilayah menurun.',
    content:
        'Operator pelabuhan dan distributor memanfaatkan jadwal pengiriman yang lebih padat untuk menekan keterlambatan suplai. Pedagang di beberapa kota besar mengaku ketersediaan stok kini lebih terjaga sehingga gejolak harga dapat diredam lebih cepat.',
    category: 'Ekonomi',
    date: DateTime(2026, 4, 27),
    readMinutes: 4,
    imageHint: 'Food Market',
    imageUrl:
        'https://images.unsplash.com/photo-1488459716781-31db52582fe9?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 89,
  ),
  _newsItem(
    id: 'n9',
    title: 'Bank Daerah Pacu Kredit Hijau untuk Renovasi Rumah Hemat Energi',
    description:
        'Skema pembiayaan baru menargetkan keluarga muda di kota menengah.',
    content:
        'Produk kredit ini memberi insentif bunga bagi nasabah yang memasang panel surya, pencahayaan hemat energi, atau sistem ventilasi efisien. Lembaga pembiayaan menilai pendekatan ini bisa membuka pasar baru sekaligus meningkatkan kesadaran konsumen terhadap hunian berkelanjutan.',
    category: 'Ekonomi',
    date: DateTime(2026, 4, 26),
    readMinutes: 5,
    imageHint: 'Home Finance',
    imageUrl:
        'https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 86,
  ),
  _newsItem(
    id: 'n10',
    title: 'Sektor Logistik Didorong Pakai Analitik untuk Pangkas Biaya Operasi',
    description:
        'Perusahaan distribusi mulai mengatur rute harian berdasarkan data permintaan.',
    content:
        'Pemanfaatan analitik operasional membantu armada mengurangi rute kosong dan menyesuaikan pengiriman dengan volume aktual. Efisiensi tersebut dinilai penting saat biaya bahan bakar dan kebutuhan layanan cepat terus menekan margin perusahaan logistik.',
    category: 'Ekonomi',
    date: DateTime(2026, 4, 25),
    readMinutes: 5,
    imageHint: 'Logistics Data',
    imageUrl:
        'https://images.unsplash.com/photo-1494412651409-8963ce7935a7?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 82,
  ),
  _newsItem(
    id: 'n11',
    title: 'Koridor TOD Surabaya Tarik Minat Pekerja Muda dan Pengembang',
    description:
        'Hunian dekat transportasi publik mulai menjadi daya tarik baru di pusat kota.',
    content:
        'Kawasan berbasis transit memberi keuntungan waktu tempuh yang lebih singkat dan akses layanan yang lebih lengkap bagi pekerja urban. Pengembang properti melihat pola ini sebagai sinyal kuat bahwa gaya hidup tanpa kendaraan pribadi makin diterima.',
    category: 'Perkotaan',
    date: DateTime(2026, 4, 24),
    readMinutes: 5,
    imageHint: 'Transit City',
    imageUrl:
        'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&w=1200&q=80',
    featured: true,
    trendingScore: 94,
  ),
  _newsItem(
    id: 'n12',
    title: 'Lampu Jalan Pintar Semarang Hemat Energi hingga 32 Persen',
    description:
        'Sensor lalu lintas dan cuaca dipakai untuk mengatur intensitas pencahayaan otomatis.',
    content:
        'Pemerintah kota menggabungkan sensor lingkungan dengan dashboard pemantauan untuk mengatur nyala lampu jalan secara dinamis. Selain menekan biaya listrik, pendekatan ini juga membantu perawatan karena titik gangguan bisa dipetakan lebih cepat.',
    category: 'Perkotaan',
    date: DateTime(2026, 4, 23),
    readMinutes: 4,
    imageHint: 'Smart Street',
    imageUrl:
        'https://images.unsplash.com/photo-1494526585095-c41746248156?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 90,
  ),
  _newsItem(
    id: 'n13',
    title: 'Trotoar Baru di Bandung Dirancang Ramah Kursi Roda dan Pesepeda',
    description:
        'Pembenahan ruang publik menitikberatkan kenyamanan pejalan kaki di pusat belanja.',
    content:
        'Desain trotoar yang lebih lebar, permukaan rata, dan jalur taktil dinilai membantu mobilitas kelompok rentan sekaligus meningkatkan kualitas kawasan komersial. Pelaku usaha sekitar mengaku arus pengunjung ikut naik setelah area menjadi lebih nyaman.',
    category: 'Perkotaan',
    date: DateTime(2026, 4, 22),
    readMinutes: 4,
    imageHint: 'Walkable Street',
    imageUrl:
        'https://images.unsplash.com/photo-1519501025264-65ba15a82390?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 87,
  ),
  _newsItem(
    id: 'n14',
    title: 'Waduk Kota Dipoles Jadi Ruang Komunal untuk Event Akhir Pekan',
    description:
        'Konsep ruang terbuka multifungsi dinilai sukses menarik keluarga muda.',
    content:
        'Revitalisasi kawasan waduk mencakup jalur lari, area duduk, titik kuliner, dan pencahayaan malam yang lebih baik. Pemerhati kota menyebut pendekatan ini efektif karena fungsi lingkungan, rekreasi, dan ekonomi lokal bisa berjalan bersamaan.',
    category: 'Perkotaan',
    date: DateTime(2026, 4, 21),
    readMinutes: 5,
    imageHint: 'Urban Lake',
    imageUrl:
        'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 84,
  ),
  _newsItem(
    id: 'n15',
    title: 'Bus Listrik Antarpermukiman Diuji pada Jam Sibuk Pagi Jakarta Timur',
    description:
        'Rute pengumpan baru ditargetkan menekan ketergantungan kendaraan pribadi.',
    content:
        'Layanan ini memfokuskan perjalanan jarak pendek dari kawasan hunian menuju simpul transportasi utama. Operator berharap pengalaman naik yang lebih nyaman dan jadwal yang presisi bisa membuat warga beralih dari kendaraan pribadi secara bertahap.',
    category: 'Perkotaan',
    date: DateTime(2026, 4, 20),
    readMinutes: 4,
    imageHint: 'Electric Bus',
    imageUrl:
        'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 81,
  ),
  _newsItem(
    id: 'n16',
    title: 'Gaya Hidup Minimalis Kembali Populer di Kalangan Profesional Muda',
    description:
        'Tren hidup sederhana dianggap membantu kesehatan mental dan fokus kerja.',
    content:
        'Komunitas digital minimalism bertumbuh di berbagai kota besar. Banyak pengguna mengurangi distraksi digital dan memprioritaskan rutinitas yang lebih sehat. Psikolog menilai pendekatan ini relevan untuk era informasi cepat.',
    category: 'Gaya Hidup',
    date: DateTime(2026, 4, 19),
    readMinutes: 7,
    imageHint: 'Minimalist Living',
    imageUrl:
        'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 89,
  ),
  _newsItem(
    id: 'n17',
    title: 'Klub Lari Subuh Makin Ramai karena Kombinasi Olahraga dan Networking',
    description:
        'Komunitas kebugaran urban kini juga jadi ruang bertemu profesional lintas bidang.',
    content:
        'Peserta menyebut format lari singkat sebelum jam kerja terasa realistis dan membantu menjaga konsistensi. Brand olahraga serta kedai kopi lokal mulai masuk mendukung acara komunitas ini karena daya tariknya terus meningkat di kota-kota besar.',
    category: 'Gaya Hidup',
    date: DateTime(2026, 4, 18),
    readMinutes: 4,
    imageHint: 'Running Club',
    imageUrl:
        'https://images.unsplash.com/photo-1483721310020-03333e577078?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 86,
  ),
  _newsItem(
    id: 'n18',
    title: 'Meja Kerja Modular Jadi Favorit bagi Pekerja Hybrid dan Kreator Konten',
    description:
        'Permintaan furnitur fleksibel naik seiring tren kerja dari rumah yang lebih mapan.',
    content:
        'Konsumen mencari perabot yang bisa menyesuaikan ruang sempit, pencahayaan, dan kebutuhan membuat konten video singkat. Produsen lokal merespons dengan desain ringkas, warna netral, dan opsi rak tambahan yang mudah dirakit.',
    category: 'Gaya Hidup',
    date: DateTime(2026, 4, 17),
    readMinutes: 5,
    imageHint: 'Work Desk',
    imageUrl:
        'https://images.unsplash.com/photo-1497366754035-f200968a6e72?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 83,
  ),
  _newsItem(
    id: 'n19',
    title: 'Tren Liburan Mikro Tiga Hari Jadi Pilihan Baru Keluarga Muda',
    description:
        'Perjalanan singkat dinilai lebih realistis untuk menjaga anggaran dan energi.',
    content:
        'Agen perjalanan melihat peningkatan minat pada paket singkat ke kota terdekat dengan aktivitas ringan. Pola ini muncul karena banyak keluarga ingin tetap mendapat jeda tanpa harus mengambil cuti panjang atau menyiapkan biaya besar.',
    category: 'Gaya Hidup',
    date: DateTime(2026, 4, 16),
    readMinutes: 4,
    imageHint: 'Weekend Trip',
    imageUrl:
        'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 80,
  ),
  _newsItem(
    id: 'n20',
    title: 'Kafe Tenang dengan Aturan Tanpa Telepon Keras Mulai Diminati',
    description:
        'Konsep ruang minum kopi yang lebih hening jadi respons atas kejenuhan kota besar.',
    content:
        'Pemilik kafe menata area dengan pencahayaan hangat, meja komunal, dan aturan sederhana agar pengunjung bisa bekerja atau berbincang dengan lebih nyaman. Model ini disebut cocok untuk pembaca, freelancer, dan pekerja hybrid yang butuh ruang fokus.',
    category: 'Gaya Hidup',
    date: DateTime(2026, 4, 15),
    readMinutes: 4,
    imageHint: 'Quiet Cafe',
    imageUrl:
        'https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 78,
  ),
  _newsItem(
    id: 'n21',
    title: 'Startup EdTech Lokal Rilis Platform Belajar Adaptif',
    description:
        'Platform menyesuaikan materi sesuai kemampuan dan ritme belajar pengguna.',
    content:
        'Dengan machine learning, platform baru dapat memetakan kelemahan konsep pengguna dan memberi latihan personal. Uji coba awal pada siswa SMA menunjukkan peningkatan pemahaman materi matematika dasar.',
    category: 'Pendidikan',
    date: DateTime(2026, 4, 14),
    readMinutes: 5,
    imageHint: 'Online Learning',
    imageUrl:
        'https://images.pexels.com/photos/5212345/pexels-photo-5212345.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 90,
  ),
  _newsItem(
    id: 'n22',
    title: 'Sekolah Kejuruan Mulai Wajibkan Portofolio Digital untuk Lulusan',
    description:
        'Guru menilai portofolio proyek lebih efektif menunjukkan kemampuan kerja siswa.',
    content:
        'Beberapa sekolah kejuruan kini menyiapkan pendampingan khusus agar siswa punya dokumentasi proyek yang rapi sebelum lulus. Industri menyambut baik langkah ini karena proses rekrutmen awal menjadi lebih cepat dan terukur.',
    category: 'Pendidikan',
    date: DateTime(2026, 4, 13),
    readMinutes: 4,
    imageHint: 'Student Portfolio',
    imageUrl:
        'https://images.pexels.com/photos/6147369/pexels-photo-6147369.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 87,
  ),
  _newsItem(
    id: 'n23',
    title: 'Kampus Negeri Buka Kelas Malam untuk Pekerja yang Ingin Reskilling',
    description:
        'Program fleksibel ini fokus pada analitik data, manajemen produk, dan komunikasi bisnis.',
    content:
        'Model perkuliahan malam memberi ruang bagi pekerja aktif untuk meningkatkan kompetensi tanpa meninggalkan pekerjaan utama. Perguruan tinggi menargetkan lulusan program singkat ini mampu langsung menerapkan materi pada proyek kantor mereka.',
    category: 'Pendidikan',
    date: DateTime(2026, 4, 12),
    readMinutes: 5,
    imageHint: 'Night Class',
    imageUrl:
        'https://images.pexels.com/photos/8471822/pexels-photo-8471822.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 84,
  ),
  _newsItem(
    id: 'n24',
    title: 'Perpustakaan Kota Tambah Zona Belajar Podcast dan Video Singkat',
    description:
        'Fasilitas baru mendukung pelajar yang belajar lewat format audio visual.',
    content:
        'Ruang ini dilengkapi perangkat rekam sederhana, headphone, dan koleksi materi multimedia yang bisa diakses gratis. Pengelola perpustakaan menyebut tren belajar modern menuntut fasilitas yang lebih dari sekadar ruang baca tradisional.',
    category: 'Pendidikan',
    date: DateTime(2026, 4, 11),
    readMinutes: 4,
    imageHint: 'Library Study',
    imageUrl:
        'https://images.pexels.com/photos/159740/library-la-trobe-study-students-159740.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 81,
  ),
  _newsItem(
    id: 'n25',
    title: 'Komunitas Guru Matematika Berbagi Modul Visual untuk Sekolah Daerah',
    description:
        'Materi ajar ringan dan siap cetak dibagikan gratis melalui platform terbuka.',
    content:
        'Inisiatif ini membantu guru di daerah yang punya keterbatasan akses perangkat dan koneksi internet stabil. Modul visual dirancang sederhana agar mudah dipakai di kelas, sekaligus memberi inspirasi bentuk penjelasan yang lebih kontekstual bagi siswa.',
    category: 'Pendidikan',
    date: DateTime(2026, 4, 10),
    readMinutes: 5,
    imageHint: 'Math Class',
    imageUrl:
        'https://images.pexels.com/photos/8471798/pexels-photo-8471798.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 79,
  ),
  _newsItem(
    id: 'n26',
    title: 'Liga Sepak Bola Nasional Catat Rekor Penonton Musim Ini',
    description:
        'Antusiasme suporter naik berkat format kompetisi baru dan ticketing digital.',
    content:
        'Perbaikan fasilitas stadion, pengalaman digital, dan jadwal pertandingan yang lebih konsisten mendorong kenaikan jumlah penonton. Pihak liga menargetkan ekspansi pasar regional musim depan.',
    category: 'Olahraga',
    date: DateTime(2026, 4, 9),
    readMinutes: 3,
    imageHint: 'Football Stadium',
    imageUrl:
        'https://images.unsplash.com/photo-1547347298-4074fc3086f0?auto=format&fit=crop&w=1200&q=80',
    featured: true,
    trendingScore: 97,
  ),
  _newsItem(
    id: 'n27',
    title: 'Pebulu Tangkis Muda Indonesia Menang Beruntun di Tur Asia',
    description:
        'Konsistensi permainan depan net jadi sorotan utama pelatih nasional.',
    content:
        'Atlet muda ini tampil meyakinkan dalam beberapa turnamen beruntun dengan peningkatan signifikan pada transisi bertahan ke menyerang. Pengamat menilai hasil tersebut membuka peluang regenerasi tim nasional yang lebih cepat.',
    category: 'Olahraga',
    date: DateTime(2026, 4, 8),
    readMinutes: 4,
    imageHint: 'Badminton Match',
    imageUrl:
        'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 92,
  ),
  _newsItem(
    id: 'n28',
    title: 'Komunitas Basket Jalanan Bangun Liga Antarwilayah dengan Sponsor Lokal',
    description:
        'Ekosistem olahraga akar rumput berkembang lewat produksi konten yang konsisten.',
    content:
        'Liga komunitas ini memanfaatkan video sorotan pertandingan dan kolaborasi brand lokal untuk menarik penonton baru. Pendekatan tersebut membuat pemain amatir punya panggung kompetitif yang terasa lebih profesional dan berkelanjutan.',
    category: 'Olahraga',
    date: DateTime(2026, 4, 7),
    readMinutes: 4,
    imageHint: 'Street Basketball',
    imageUrl:
        'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 86,
  ),
  _newsItem(
    id: 'n29',
    title: 'Renang Perairan Terbuka Jadi Cabang Favorit Baru untuk Event Wisata',
    description:
        'Daerah pesisir mulai menggabungkan lomba olahraga dengan promosi destinasi.',
    content:
        'Penyelenggara melihat format renang perairan terbuka efektif menarik peserta sekaligus wisatawan. Dengan pengamanan dan promosi yang baik, agenda seperti ini bisa menjadi kombinasi kuat antara sport tourism dan ekonomi lokal.',
    category: 'Olahraga',
    date: DateTime(2026, 4, 6),
    readMinutes: 5,
    imageHint: 'Open Water Swim',
    imageUrl:
        'https://images.unsplash.com/photo-1438029071396-1e831a7fa6d8?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 82,
  ),
  _newsItem(
    id: 'n30',
    title: 'Pelatih Kebugaran Soroti Pentingnya Recovery untuk Pelari Pemula',
    description:
        'Latihan tanpa pola pemulihan yang baik dinilai meningkatkan risiko cedera ringan.',
    content:
        'Program lari pemula kini banyak menambahkan edukasi tentang tidur, hidrasi, dan latihan mobilitas agar peserta tidak cepat cedera. Pendekatan menyeluruh ini dinilai penting untuk menjaga konsistensi, bukan hanya mengejar target jarak mingguan.',
    category: 'Olahraga',
    date: DateTime(2026, 4, 5),
    readMinutes: 4,
    imageHint: 'Fitness Recovery',
    imageUrl:
        'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 78,
  ),
  _newsItem(
    id: 'n31',
    title: 'Peneliti Lokal Temukan Baterai Cepat Isi untuk Motor Listrik',
    description:
        'Prototipe baru diklaim memangkas waktu pengisian hingga setengahnya.',
    content:
        'Tim riset kampus dan industri mengembangkan material baterai baru yang meningkatkan efisiensi termal saat pengisian daya. Jika lolos uji produksi massal, teknologi ini berpotensi mempercepat adopsi kendaraan listrik roda dua di Indonesia.',
    category: 'Inovasi',
    date: DateTime(2026, 4, 4),
    readMinutes: 6,
    imageHint: 'Electric Battery',
    imageUrl:
        'https://images.pexels.com/photos/9800005/pexels-photo-9800005.jpeg?auto=compress&cs=tinysrgb&w=1200',
    featured: true,
    trendingScore: 95,
  ),
  _newsItem(
    id: 'n32',
    title: 'Nelayan Sulawesi Uji Sensor Cuaca Murah Buatan Mahasiswa',
    description:
        'Perangkat portabel membantu pembacaan arah angin dan gelombang sebelum melaut.',
    content:
        'Sensor sederhana ini dirancang agar mudah dirawat dan tidak bergantung pada perangkat mahal. Tim pengembang menilai penggunaan teknologi yang tepat guna jauh lebih penting daripada fitur berlebihan ketika diterapkan pada komunitas pesisir.',
    category: 'Inovasi',
    date: DateTime(2026, 4, 3),
    readMinutes: 5,
    imageHint: 'Fishing Sensor',
    imageUrl:
        'https://images.pexels.com/photos/1001682/pexels-photo-1001682.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 89,
  ),
  _newsItem(
    id: 'n33',
    title: 'Printer 3D Skala Kecil Dipakai Bengkel untuk Suku Cadang Cepat',
    description:
        'Pelaku usaha otomotif melihat manfaat besar pada produksi komponen non-mesin.',
    content:
        'Dengan printer 3D, bengkel bisa membuat prototipe cover, bracket, atau pengait khusus dalam hitungan jam. Solusi ini mengurangi ketergantungan pada pengiriman barang kecil dari luar kota dan membantu proses servis jadi lebih cepat.',
    category: 'Inovasi',
    date: DateTime(2026, 4, 2),
    readMinutes: 4,
    imageHint: '3D Printer',
    imageUrl:
        'https://images.pexels.com/photos/1108572/pexels-photo-1108572.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 85,
  ),
  _newsItem(
    id: 'n34',
    title: 'Kemasan Pangan Ramah Lingkungan dari Rumput Laut Mulai Diuji Pasar',
    description:
        'Produk inovatif ini menyasar usaha makanan premium dan katering sehat.',
    content:
        'Material turunan rumput laut dinilai menjanjikan karena ketersediaannya cukup baik dan jejak limbahnya lebih kecil. Produsen masih menguji ketahanan terhadap kelembapan, tetapi minat pasar awal disebut sangat positif.',
    category: 'Inovasi',
    date: DateTime(2026, 4, 1),
    readMinutes: 5,
    imageHint: 'Eco Packaging',
    imageUrl:
        'https://images.pexels.com/photos/4498136/pexels-photo-4498136.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 82,
  ),
  _newsItem(
    id: 'n35',
    title: 'Studio Audio Lokal Bangun Alat Perekam Lapangan untuk Kreator Dokumenter',
    description:
        'Perangkat ringkas ini dirancang tangguh untuk kondisi cuaca tropis.',
    content:
        'Tim pengembang fokus pada keawetan baterai, kejernihan tangkapan suara, dan bodi yang tahan lembap agar cocok dipakai di lapangan. Kreator independen menilai inovasi perangkat seperti ini bisa menurunkan hambatan produksi konten berkualitas.',
    category: 'Inovasi',
    date: DateTime(2026, 3, 31),
    readMinutes: 4,
    imageHint: 'Audio Recorder',
    imageUrl:
        'https://images.pexels.com/photos/164938/pexels-photo-164938.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 79,
  ),
  _newsItem(
    id: 'n36',
    title: 'Wisata Bahari Timur Indonesia Menarik Lonjakan Pengunjung Premium',
    description:
        'Operator tur mencatat kenaikan pemesanan paket pengalaman eksklusif.',
    content:
        'Destinasi laut di kawasan timur Indonesia semakin diminati oleh wisatawan domestik dan internasional. Pelaku usaha menyebut kombinasi konservasi, layanan privat, dan promosi digital menjadi pendorong utama tren ini.',
    category: 'Wisata',
    date: DateTime(2026, 3, 30),
    readMinutes: 4,
    imageHint: 'Ocean Travel',
    imageUrl:
        'https://images.pexels.com/photos/457882/pexels-photo-457882.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 88,
  ),
  _newsItem(
    id: 'n37',
    title: 'Kereta Panorama ke Kawasan Pegunungan Mulai Dipesan Jauh Hari',
    description:
        'Wisatawan memburu perjalanan lambat dengan pemandangan alam yang fotogenik.',
    content:
        'Operator melihat tren baru pada perjalanan yang menekankan pengalaman di sepanjang rute, bukan hanya tujuan akhir. Paket wisata ini sering dipadukan dengan penginapan butik dan kuliner lokal untuk menciptakan kesan premium.',
    category: 'Wisata',
    date: DateTime(2026, 3, 29),
    readMinutes: 4,
    imageHint: 'Mountain Train',
    imageUrl:
        'https://images.pexels.com/photos/210243/pexels-photo-210243.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 85,
  ),
  _newsItem(
    id: 'n38',
    title: 'Desa Wisata Kopi di Flores Siapkan Paket Panen dan Kelas Rasa',
    description:
        'Pengalaman berbasis cerita lokal dinilai lebih menarik bagi wisatawan muda.',
    content:
        'Pengunjung diajak melihat proses dari kebun hingga seduhan, lalu berdialog langsung dengan petani dan peracik kopi setempat. Model wisata seperti ini dianggap efektif memperpanjang lama tinggal wisatawan sekaligus meningkatkan nilai ekonomi lokal.',
    category: 'Wisata',
    date: DateTime(2026, 3, 28),
    readMinutes: 5,
    imageHint: 'Coffee Village',
    imageUrl:
        'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 83,
  ),
  _newsItem(
    id: 'n39',
    title: 'Hotel Kota Lama Andalkan Paket Staycation dengan Jelajah Kuliner',
    description:
        'Pelaku industri melihat tamu domestik ingin pengalaman singkat namun berkesan.',
    content:
        'Paket baru menggabungkan tur jalan kaki, diskon restoran lokal, dan panduan rute foto favorit. Strategi ini membantu hotel membedakan diri di tengah persaingan harga yang ketat pada musim perjalanan pendek.',
    category: 'Wisata',
    date: DateTime(2026, 3, 27),
    readMinutes: 4,
    imageHint: 'Heritage Hotel',
    imageUrl:
        'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 80,
  ),
  _newsItem(
    id: 'n40',
    title: 'Pendakian Ramah Pemula di Jawa Barat Makin Populer Berkat Reservasi Digital',
    description:
        'Jalur favorit kini lebih tertib karena kuota dan jadwal kunjungan dipantau daring.',
    content:
        'Sistem reservasi membantu pengelola menjaga kapasitas kawasan sekaligus memberi rasa aman bagi pendaki pemula. Komunitas outdoor menilai pengaturan seperti ini membuat pengalaman mendaki lebih nyaman tanpa mengurangi daya tarik alam.',
    category: 'Wisata',
    date: DateTime(2026, 3, 26),
    readMinutes: 4,
    imageHint: 'Mountain Hike',
    imageUrl:
        'https://images.pexels.com/photos/691668/pexels-photo-691668.jpeg?auto=compress&cs=tinysrgb&w=1200',
    trendingScore: 78,
  ),
  _newsItem(
    id: 'n41',
    title: 'Brand Fashion Lokal Uji Coba Produksi Berbasis Daur Ulang',
    description:
        'Koleksi baru memanfaatkan limbah tekstil untuk lini pakaian harian.',
    content:
        'Beberapa label fashion lokal mulai membangun rantai pasok sirkular dengan memanfaatkan bahan sisa produksi. Konsumen muda disebut menjadi segmen paling responsif terhadap produk yang menonjolkan transparansi bahan dan jejak lingkungan.',
    category: 'Bisnis',
    date: DateTime(2026, 3, 25),
    readMinutes: 5,
    imageHint: 'Sustainable Fashion',
    imageUrl:
        'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 87,
  ),
  _newsItem(
    id: 'n42',
    title: 'Jaringan Kopi Lokal Ekspansi lewat Gerai Kecil Dekat Perkantoran',
    description:
        'Format toko ringkas dipilih agar biaya operasional tetap sehat.',
    content:
        'Alih-alih membuka gerai besar, brand kopi memilih konsep kiosk premium dengan menu cepat saji untuk area komuter. Strategi ini dianggap lebih lincah dalam menguji pasar sekaligus menjaga pengalaman merek tetap konsisten.',
    category: 'Bisnis',
    date: DateTime(2026, 3, 24),
    readMinutes: 4,
    imageHint: 'Coffee Shop',
    imageUrl:
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 84,
  ),
  _newsItem(
    id: 'n43',
    title: 'Produsen Skincare Domestik Naik Kelas lewat Riset Bahan Tropis',
    description:
        'Pelaku industri kecantikan melihat peluang besar pada bahan aktif lokal.',
    content:
        'Investasi pada riset bahan dan pengujian stabilitas produk membuat merek lokal lebih percaya diri memasuki pasar premium. Distributor menilai narasi kualitas ilmiah kini sama pentingnya dengan strategi promosi digital.',
    category: 'Bisnis',
    date: DateTime(2026, 3, 23),
    readMinutes: 5,
    imageHint: 'Skincare Lab',
    imageUrl:
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 82,
  ),
  _newsItem(
    id: 'n44',
    title: 'Studio Gim Independen Cari Pendapatan Baru dari Merchandise Resmi',
    description:
        'Model bisnis campuran dinilai membantu studio kecil bertahan lebih lama.',
    content:
        'Selain mengandalkan penjualan gim, studio mulai mengembangkan kaus, buku seni, dan aksesori koleksi untuk membangun komunitas yang lebih loyal. Pendekatan ini memberi ruang tambahan bagi pemasukan ketika siklus rilis produk utama cukup panjang.',
    category: 'Bisnis',
    date: DateTime(2026, 3, 22),
    readMinutes: 4,
    imageHint: 'Game Studio',
    imageUrl:
        'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 79,
  ),
  _newsItem(
    id: 'n45',
    title: 'Rantai Toko Bahan Bangunan Pakai Aplikasi untuk Prediksi Permintaan',
    description:
        'Stok proyek rumah tinggal kini disesuaikan dengan tren pembangunan kawasan.',
    content:
        'Analisis permintaan membantu toko menentukan komposisi stok semen, cat, dan perlengkapan rumah berdasarkan dinamika pembangunan lokal. Pengelola mengaku langkah ini mengurangi barang lambat bergerak dan mempercepat respons ke pelanggan utama.',
    category: 'Bisnis',
    date: DateTime(2026, 3, 21),
    readMinutes: 5,
    imageHint: 'Building Store',
    imageUrl:
        'https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 77,
  ),
  _newsItem(
    id: 'n46',
    title: 'Rumah Sakit Gunakan AI Triage untuk Percepat Layanan Darurat',
    description:
        'Sistem membantu prioritisasi pasien berdasarkan gejala awal dan risiko.',
    content:
        'Beberapa rumah sakit di kota besar mulai menguji sistem triage berbasis AI untuk mempersingkat waktu tunggu pasien gawat darurat. Tenaga medis tetap menjadi pengambil keputusan utama, tetapi sistem baru membantu menyusun prioritas dengan lebih cepat.',
    category: 'Kesehatan',
    date: DateTime(2026, 3, 20),
    readMinutes: 7,
    imageHint: 'Hospital AI',
    imageUrl:
        'https://images.unsplash.com/photo-1516549655169-df83a0774514?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 91,
  ),
  _newsItem(
    id: 'n47',
    title: 'Klinik Gigi Keluarga Tambah Konsultasi Singkat via Aplikasi',
    description:
        'Layanan pra-kunjungan membantu pasien menilai urgensi masalah sebelum datang.',
    content:
        'Model konsultasi awal ini membuat dokter gigi bisa memberi arahan sederhana sambil mengatur prioritas jadwal kunjungan. Pasien mengaku terbantu karena dapat menilai tindakan yang perlu segera dilakukan tanpa menunggu terlalu lama.',
    category: 'Kesehatan',
    date: DateTime(2026, 3, 19),
    readMinutes: 4,
    imageHint: 'Dental Care',
    imageUrl:
        'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 86,
  ),
  _newsItem(
    id: 'n48',
    title: 'Menu Kantor Sehat Berbasis Protein Lokal Makin Banyak Dicari',
    description:
        'Permintaan makan siang bernutrisi naik di kalangan pekerja urban.',
    content:
        'Penyedia katering sehat mulai mengolah bahan lokal seperti tempe, ikan, dan sayur musiman dalam menu praktis untuk pekerja kantor. Ahli gizi melihat tren ini positif karena menggeser pola makan cepat saji ke pilihan yang lebih seimbang.',
    category: 'Kesehatan',
    date: DateTime(2026, 3, 18),
    readMinutes: 4,
    imageHint: 'Healthy Lunch',
    imageUrl:
        'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 83,
  ),
  _newsItem(
    id: 'n49',
    title: 'Aplikasi Kebugaran Lokal Tambah Program Pemula dengan Pelatih Langsung',
    description:
        'Pendekatan pendampingan dinilai membuat pengguna lebih konsisten berolahraga.',
    content:
        'Pengembang aplikasi melihat banyak pengguna berhenti berolahraga karena target terlalu tinggi di awal. Program baru ini memecah latihan menjadi langkah kecil dengan umpan balik pelatih agar progres terasa lebih realistis dan aman.',
    category: 'Kesehatan',
    date: DateTime(2026, 3, 17),
    readMinutes: 5,
    imageHint: 'Fitness App',
    imageUrl:
        'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 80,
  ),
  _newsItem(
    id: 'n50',
    title: 'Puskesmas Kota Mulai Buka Sesi Edukasi Kesehatan Mental untuk Orang Tua',
    description:
        'Program komunitas ini menyoroti stres pengasuhan dan pentingnya dukungan rumah.',
    content:
        'Tenaga kesehatan menilai edukasi berbasis komunitas penting agar keluarga lebih cepat mengenali tanda kelelahan emosional. Forum tatap muka dan materi sederhana membantu orang tua memahami kapan perlu mencari bantuan profesional secara lebih dini.',
    category: 'Kesehatan',
    date: DateTime(2026, 3, 16),
    readMinutes: 5,
    imageHint: 'Mental Health Talk',
    imageUrl:
        'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?auto=format&fit=crop&w=1200&q=80',
    trendingScore: 78,
  ),
];
