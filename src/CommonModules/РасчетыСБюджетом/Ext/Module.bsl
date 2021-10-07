﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ВидыНалогов

// Возвращает счет учета для указанного налога
//
Функция СчетУчета(ВидНалога, Знач Период = Неопределено) Экспорт
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	ТаблицаСоответствияСчетовУчета = ТаблицаСоответствияСчетовУчета();
	НайденныеСтроки = ТаблицаСоответствияСчетовУчета.НайтиСтроки(Новый Структура("ВидНалога", ВидНалога));
	
	Если НайденныеСтроки.Количество() = 1 Тогда
		
		СчетУчета = НайденныеСтроки[0].СчетУчета;
		
	ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
		// Есть устаревшие счета учета
		Если ВидНалога = Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть 
			Или ВидНалога = Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть Тогда
			
			Если Период < '20140101' Тогда
				СчетУчета = НайденныеСтроки[1].СчетУчета;
			Иначе
				СчетУчета = НайденныеСтроки[0].СчетУчета;
			КонецЕсли;
			
		Иначе
			СчетУчета = НайденныеСтроки[0].СчетУчета;
		КонецЕсли;
	Иначе
		СчетУчета = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	КонецЕсли;
	
	Возврат СчетУчета;
	
КонецФункции

Функция ВидНалогаПоСчетуУчета(СчетУчета, Организация = Неопределено, Знач Период = Неопределено, УровеньБюджета = Неопределено) Экспорт
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СчетУчета) Тогда
		Возврат Перечисления.ВидыНалогов.ПустаяСсылка();
	ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ПрочиеНалогиИСборы Тогда
		Возврат Перечисления.ВидыНалогов.ПрочиеНалогиИСборы;
	КонецЕсли;
	
	ТаблицаСоответствияСчетовУчета = ТаблицаСоответствияСчетовУчета();
	НайденныеСтроки = ТаблицаСоответствияСчетовУчета.НайтиСтроки(Новый Структура("СчетУчета", СчетУчета));
	
	Если НайденныеСтроки.Количество() = 1 Тогда
		
		ВидНалога = НайденныеСтроки[0].ВидНалога;
		
	ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
		// На одном счете учитываются разные виды налогов
		Если СчетУчета = ПланыСчетов.Хозрасчетный.РасчетыСБюджетом И ЗначениеЗаполнено(УровеньБюджета) Тогда
			
			Если УровеньБюджета = Перечисления.УровниБюджетов.РегиональныйБюджет Тогда
				ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет;
			Иначе
				ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет;
			КонецЕсли;
			
		ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.ЕНприУСН И ЗначениеЗаполнено(Организация) Тогда
			
			Если УчетнаяПолитика.ОбъектНалогообложенияУСН(Организация, Период) = Перечисления.ОбъектыНалогообложенияПоУСН.Доходы Тогда
				ВидНалога = Перечисления.ВидыНалогов.УСН_Доходы;
			Иначе
				ВидНалога = Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы;
			КонецЕсли;
			
		ИначеЕсли СчетУчета = ПланыСчетов.Хозрасчетный.НДС
			Или СчетУчета = ПланыСчетов.Хозрасчетный.НДСНалоговогоАгента
			Или СчетУчета = ПланыСчетов.Хозрасчетный.НДСТаможенныйСоюзКУплате Тогда
			
			ВидНалога = Перечисления.ВидыНалогов.НДС;
			
		Иначе
			// Подходит несколько видов налога, но, возможно, уплачивается только один
			ВидНалога = ПрименяемыйВидНалога(ОбщегоНазначения.ВыгрузитьКолонку(НайденныеСтроки, "ВидНалога", Истина), СчетУчета);
		КонецЕсли;
		
	Иначе
		
		ВидНалога = Перечисления.ВидыНалогов.ПрочиеНалогиИСборы;
		
	КонецЕсли;
	
	Возврат ВидНалога;
	
КонецФункции

Функция ВидНалогаПоКодуЗадачи(КодЗадачи, Организация, Знач Период = Неопределено) Экспорт
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ПустаяСтрока(КодЗадачи) Тогда
		Возврат Перечисления.ВидыНалогов.ПустаяСсылка();
	КонецЕсли;
	
	ТаблицаСоответствияЗадачБухгалтера = ТаблицаСоответствияЗадачБухгалтера();
	НайденныеСтроки = ТаблицаСоответствияЗадачБухгалтера.НайтиСтроки(Новый Структура("КодЗадачи", КодЗадачи));
	
	Если НайденныеСтроки.Количество() = 1 Тогда
		
		ВидНалога = НайденныеСтроки[0].ВидНалога;
		
	ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
		// Коду задачи соответствует несколько видов налога
		Если КодЗадачи = "УСН" И ЗначениеЗаполнено(Организация) Тогда
			Если УчетнаяПолитика.ОбъектНалогообложенияУСН(Организация, Период) = Перечисления.ОбъектыНалогообложенияПоУСН.Доходы Тогда
				ВидНалога = Перечисления.ВидыНалогов.УСН_Доходы;
			Иначе
				ВидНалога = Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы;
			КонецЕсли;
		ИначеЕсли КодЗадачи = ЗадачиБухгалтераКлиентСервер.КодЗадачиНДФЛПредприниматель()
				И ЗначениеЗаполнено(Организация) Тогда
			ВидНалога = Перечисления.ВидыНалогов.НДФЛ_ИП;
		Иначе
			// Подходит несколько видов налога, но, возможно, уплачивается только один
			ВидНалога = ПрименяемыйВидНалога(ОбщегоНазначения.ВыгрузитьКолонку(НайденныеСтроки, "ВидНалога", Истина));
		КонецЕсли;
	Иначе
		ВидНалога = Перечисления.ВидыНалогов.ПрочиеНалогиИСборы;
	КонецЕсли;
	
	Возврат ВидНалога;
	
КонецФункции

Функция ВидыНалоговПоКодуЗадачи(КодЗадачи, Организация, Знач Период = Неопределено) Экспорт
	
	Если Период = Неопределено Тогда
		Период = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Если ПустаяСтрока(КодЗадачи) Тогда
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.ВидыНалогов.ПустаяСсылка());
	КонецЕсли;
	
	ТаблицаСоответствияЗадачБухгалтера = ТаблицаСоответствияЗадачБухгалтера();
	НайденныеСтроки = ТаблицаСоответствияЗадачБухгалтера.НайтиСтроки(Новый Структура("КодЗадачи", КодЗадачи));
	
	Если НайденныеСтроки.Количество() = 0 Тогда
		
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Перечисления.ВидыНалогов.ПустаяСсылка());
		
	Иначе
		
		Возврат ОбщегоНазначения.ВыгрузитьКолонку(НайденныеСтроки, "ВидНалога", Истина);
		
	КонецЕсли;
	
КонецФункции

// Возвращает уровень бюджета для указанного налога
//
Функция УровеньБюджета(ВидНалога) Экспорт
	
	Если ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет
		Или ВидНалога = Перечисления.ВидыНалогов.ЕСХН Тогда
		УровеньБюджета = Перечисления.УровниБюджетов.ФедеральныйБюджет;
	ИначеЕсли ВидНалога = Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет Тогда
		УровеньБюджета = Перечисления.УровниБюджетов.РегиональныйБюджет;
	Иначе
		УровеньБюджета = Перечисления.УровниБюджетов.ПустаяСсылка();
	КонецЕсли;
	
	Возврат УровеньБюджета;
	
КонецФункции

Функция НалоговыйАгент(ВидНалога) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ВидНалога = Перечисления.ВидыНалогов.НДФЛ Тогда
		НалоговыйАгент = Истина;
	Иначе
		НалоговыйАгент = Ложь;
	КонецЕсли;
	
	Возврат НалоговыйАгент;
	
КонецФункции

// Возвращает необходимые виды налогов для ИБ
//
Функция НеобходимыеВидыНалогов() Экспорт
	
	ВидыНалогов = Новый Массив;
	
	Если УчетЗарплаты.ВключенаПодсистемаУчетаЗарплатыИКадров() Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС_НСиПЗ);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ФФОМС);
		ИзмененныеОпцииПодсистемы = ИзмененныеОпцииПодсистемыУчетаЗарплатыИКадров();
		Если ИзмененныеОпцииПодсистемы.ИспользуетсяТрудЧленовЛетныхЭкипажей Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ЛетныеЭкипажи);
		КонецЕсли;
		Если ИзмененныеОпцииПодсистемы.ИспользуетсяТрудШахтеров Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_Шахтеры);
		КонецЕсли;
		Если ИзмененныеОпцииПодсистемы.ИспользуютсяРаботыСДосрочнойПенсией Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ВредныеУсловия);
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ТяжелыеУсловия);
		КонецЕсли;
		Если ИзмененныеОпцииПодсистемы.УдерживаютсяДобровольныеВзносыВПФР Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_Добровольные);
		КонецЕсли;
	КонецЕсли;
	
	ИспользуемыеСистемыНалогообложения = РегистрыСведений.НастройкиСистемыНалогообложения.ИспользуемыеСистемыНалогообложения();
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяОСНО
		Или ИспользуемыеСистемыНалогообложения.ИспользуетсяНДФЛИП Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НДС);
	КонецЕсли;
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяОСНО Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет);
	КонецЕсли;
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяУСНДоходы Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.УСН_Доходы);
	КонецЕсли;
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяУСНДоходыМинусРасходы Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.УСН_МинимальныйНалог);
	КонецЕсли;
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяНДФЛИП Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ИП);
	КонецЕсли;
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяУСНПатент Тогда
		
		КатегорииПодчинения = Перечисления.УсловияПримененияТребованийЗаконодательства.КатегорииПодчиненияПатентовПоВидамНалогов();
		Для каждого КатегорияПодчинения Из КатегорииПодчинения Цикл
			Если КатегорияПодчинения = "010" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородскойОкруг);
			ИначеЕсли КатегорияПодчинения = "020" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_МуниципальныйРайон);
			ИначеЕсли КатегорияПодчинения = "030" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородФедеральногоЗначения);
			ИначеЕсли КатегорияПодчинения = "040" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородскойОкругСВнутригородскимДелением);
			ИначеЕсли КатегорияПодчинения = "050" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ВнутригородскойРайон);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли; 
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяЕНВД Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЕНВД);
	КонецЕсли;
	
	Если ИспользуемыеСистемыНалогообложения.ИспользуетсяНалогНаПрофессиональныйДоход Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход);
	КонецЕсли;
	
	Если Константы.ВестиУчетИндивидуальногоПредпринимателя.Получить() Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть);
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ФФОМС);
		Если РегистрыСведений.НастройкиУчетаСтраховыхВзносовИП.УплачиваютсяДобровольныеВзносыВФСС() Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ФСС);
		КонецЕсли;
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ФизЛицо);
	КонецЕсли;
	
	Если Константы.ВестиУчетЮридическогоЛица.Получить() И Константы.ВедетсяУчетОсновныхСредств.Получить() Тогда
		
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаИмущество);
		
		Если Перечисления.УсловияПримененияТребованийЗаконодательства.ЕстьИмуществоЕСГС() Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаИмуществоЕСГС);
		КонецЕсли;
		
		Если Перечисления.УсловияПримененияТребованийЗаконодательства.ЕстьТранспортныеСредства() Тогда
			ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ТранспортныйНалог);
		КонецЕсли;
		
		КатегорииПодчинения = Перечисления.УсловияПримененияТребованийЗаконодательства.КатегорииПодчиненияЗемельныхУчастковПоВидамНалогов();
		Для каждого КатегорияПодчинения Из КатегорииПодчинения Цикл
			Если КатегорияПодчинения = "103" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородФедеральногоЗначения);
			ИначеЕсли КатегорияПодчинения = "204" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкруг);
			ИначеЕсли КатегорияПодчинения = "211" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкругСВнутригородскимДелением);
			ИначеЕсли КатегорияПодчинения = "212" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ВнутригородскойОкруг);
			ИначеЕсли КатегорияПодчинения = "305" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_МежселеннаяТерритория);
			ИначеЕсли КатегорияПодчинения = "310" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_СельскоеПоселение);
			ИначеЕсли КатегорияПодчинения = "313" Тогда
				ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскоеПоселение);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если Перечисления.УсловияПримененияТребованийЗаконодательства.ЕстьОбъектыТорговогоСбора()
		ИЛИ ИспользуемыеСистемыНалогообложения.ИспользуетсяТорговыйСбор Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ТорговыйСбор);
	КонецЕсли;
	
	Если Константы.ВестиУчетЮридическогоЛица.Получить() Тогда
		ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_НалоговыйАгент);
	КонецЕсли;
	
	Возврат ВидыНалогов;
	
КонецФункции

Функция ВидыНалогов() Экспорт
	
	Результат = Новый Структура;
	
	КоллекцияМетаданных = Перечисления.ВидыНалогов.Получить(0).Метаданные().ЗначенияПеречисления;
	
	Для Индекс = 0 По КоллекцияМетаданных.Количество() - 1 Цикл
		Результат.Вставить(КоллекцияМетаданных[Индекс].Имя, Перечисления.ВидыНалогов.Получить(Индекс));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ИмяЗадачиБухгалтера(ВидНалога) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаСоответствияЗадачБухгалтера = ТаблицаСоответствияЗадачБухгалтера();
	НайденнаяСтрока = ТаблицаСоответствияЗадачБухгалтера.Найти(ВидНалога, "ВидНалога");
	
	Если НайденнаяСтрока = Неопределено Тогда
		Возврат "";
	Иначе
		Возврат НайденнаяСтрока.КодЗадачи;
	КонецЕсли;
	
КонецФункции

// Возвращает массив видов налогов, уплачиваемых исключительно физическими лицами
//
Функция ВидыНалоговФизическихЛиц() Экспорт
	
	ВидыНалогов = Новый Массив;
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ИП);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НДФЛ_ФизЛицо);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_НакопительнаяЧасть);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ФФОМС);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ФиксированныеВзносы_ФСС);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородскойОкруг);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_МуниципальныйРайон);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородФедеральногоЗначения);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ГородскойОкругСВнутригородскимДелением);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ПСН_ВнутригородскойРайон);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход);
	
	Возврат ВидыНалогов;
	
КонецФункции

// Возвращает массив видов налогов, уплачиваемых исключительно юридическими лицами
//
Функция ВидыНалоговЮридическихЛиц() Экспорт
	
	ВидыНалогов = Новый Массив;
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаПрибыль_НалоговыйАгент);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородФедеральногоЗначения);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкруг);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкругСВнутригородскимДелением);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ВнутригородскойОкруг);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_МежселеннаяТерритория);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_СельскоеПоселение);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскоеПоселение);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.ТранспортныйНалог);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаИмущество);
	ВидыНалогов.Добавить(Перечисления.ВидыНалогов.НалогНаИмуществоЕСГС);
	
	Возврат ВидыНалогов;
	
КонецФункции

// Возвращает ссылку на значение перечисления "ВидыНалогов" по переданному имени.
//
// Возвращаемое значение:
//   ПеречислениеСсылка.ВидыНалогов - ссылка на найденное значение перечисление или ПустаяСсылка().
//
Функция ВидНалогаПоИмени(ИмяВидаНалога) Экспорт
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.ВидыНалогов.ЗначенияПеречисления Цикл
		
		Если ВРег(ЗначениеПеречисления.Имя) = ВРег(ИмяВидаНалога) Тогда
			Возврат Перечисления.ВидыНалогов[ЗначениеПеречисления.Имя];
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Перечисления.ВидыНалогов.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#Область АналитикаНаСчетах68и69

// В качестве РегистрацияВНалоговомОргане можно передавать КПП. В этом случае регистрация ищется по КПП
Функция АналитикаНаСчетеРасчетовСБюджетом(Счет, Организация, РегистрацияВНалоговомОргане, ВидНалоговогоОбязательства, КБК, ОснованиеПлатежа, ТипПлатежа, ВключаяОборотныеСубконто = Истина) Экспорт
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ВидСубконто",  Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.ВидыСубконтоХозрасчетные"));
	Результат.Колонки.Добавить("НомерНаСчете", Новый ОписаниеТипов("Число"));
	Результат.Колонки.Добавить("Значение");
	
	ВидыСубконтоСчета = Счет.ВидыСубконто;
	
	Для НомерСубконто = 1 По ВидыСубконтоСчета.Количество() Цикл
		
		ВидСубконтоНаСчете = ВидыСубконтоСчета[НомерСубконто - 1];
		
		Если Не ВключаяОборотныеСубконто И ВидСубконтоНаСчете.ТолькоОбороты Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяСубконто = ВидСубконтоНаСчете.ВидСубконто.ИмяПредопределенныхДанных;
		
		Если ИмяСубконто = "ВидыПлатежейВГосБюджет" Тогда
			Если ЗначениеЗаполнено(ВидНалоговогоОбязательства) Тогда
				Значение = Перечисления.ВидыПлатежейВГосБюджет.ВидПлатежа(ВидНалоговогоОбязательства);
			Иначе
				Значение = ВидПлатежаВГосБюджет(КБК, ОснованиеПлатежа, ТипПлатежа);
			КонецЕсли;
		ИначеЕсли ИмяСубконто = "УровниБюджетов" Тогда
			Значение = УровеньБюджета(КБК);
		ИначеЕсли ИмяСубконто = "РегистрацияВНалоговомОргане" Тогда
			Значение = РегистрацияВНалоговомОргане;
		Иначе
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Результат.Добавить();
		НоваяСтрока.ВидСубконто  = ВидСубконтоНаСчете.ВидСубконто;
		НоваяСтрока.НомерНаСчете = НомерСубконто;
		НоваяСтрока.Значение     = Значение;
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

Функция ВидПлатежаВГосБюджет(КБК, КодОснования, ТипПлатежа = Неопределено)
	
	Если Не ПлатежиВБюджетКлиентСервер.КБКЗадан(КБК) Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.ПустаяСсылка");
	КонецЕсли;
	
	Если ПлатежиВБюджетКлиентСервер.ЭтоКБКПениПроценты(КБК) 
		Или ТипПлатежа = ПлатежиВБюджетКлиентСервер.ТипПлатежаПени() Тогда
		
		Если ПлатежиВБюджетКлиентСервер.ЭтоПогашениеЗадолженностиПоАктуПроверки(КодОснования) Тогда
			Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.ПениАкт");
		Иначе
			Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.ПениСам");
		КонецЕсли;
		
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоКБКПениПроценты(КБК) 
		Или ТипПлатежа = ПлатежиВБюджетКлиентСервер.ТипПлатежаПроценты() Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.Проценты");
		
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоКБКШтраф(КБК) 
		Или ПлатежиВБюджетКлиентСервер.ЭтоТипПлатежаШтраф(ТипПлатежа) Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.Штраф");
		
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоДобровольноеПогашениеЗадолженности(КодОснования) Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.НалогСам");
		
	ИначеЕсли ПлатежиВБюджетКлиентСервер.ЭтоПогашениеЗадолженностиПоАктуПроверки(КодОснования) Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.НалогАкт");
		
	Иначе
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПлатежейВГосБюджет.Налог");
		
	КонецЕсли;
	
КонецФункции

// Для функциональных опций из ПроверяемыеОпцииПодсистемы проверяет, включены ли они сейчас,
// если не были включены ранее (т.е. если в ПроверяемыеОпцииПодсистемы значение опции = Ложь).
//
Функция ИзмененныеОпцииПодсистемыУчетаЗарплатыИКадров(ПроверяемыеОпцииПодсистемы = Неопределено) Экспорт
	
	Если ПроверяемыеОпцииПодсистемы = Неопределено Тогда
		ПроверяемыеОпцииПодсистемы = Новый Структура;
		ПроверяемыеОпцииПодсистемы.Вставить("ИспользуетсяТрудЧленовЛетныхЭкипажей", Ложь);
		ПроверяемыеОпцииПодсистемы.Вставить("ИспользуетсяТрудШахтеров",             Ложь);
		ПроверяемыеОпцииПодсистемы.Вставить("ИспользуютсяРаботыСДосрочнойПенсией",  Ложь);
		ПроверяемыеОпцииПодсистемы.Вставить("УдерживаютсяДобровольныеВзносыВПФР",   Ложь);
	КонецЕсли;
	
	ВключаемыеОпцииПодсистемы = Новый Структура;
	Если ПроверяемыеОпцииПодсистемы.ИспользуетсяТрудЧленовЛетныхЭкипажей Тогда
		ВключаемыеОпцииПодсистемы.Вставить("ИспользуетсяТрудЧленовЛетныхЭкипажей", Ложь);
	Иначе
		ВключаемыеОпцииПодсистемы.Вставить("ИспользуетсяТрудЧленовЛетныхЭкипажей", УчетЗарплаты.ИспользуетсяТрудЧленовЛетныхЭкипажей());
	КонецЕсли;
	Если ПроверяемыеОпцииПодсистемы.ИспользуетсяТрудШахтеров Тогда
		ВключаемыеОпцииПодсистемы.Вставить("ИспользуетсяТрудШахтеров", Ложь);
	Иначе
		ВключаемыеОпцииПодсистемы.Вставить("ИспользуетсяТрудШахтеров", УчетЗарплаты.ИспользуетсяТрудШахтеров());
	КонецЕсли;
	Если ПроверяемыеОпцииПодсистемы.ИспользуютсяРаботыСДосрочнойПенсией Тогда
		ВключаемыеОпцииПодсистемы.Вставить("ИспользуютсяРаботыСДосрочнойПенсией", Ложь);
	Иначе
		ВключаемыеОпцииПодсистемы.Вставить("ИспользуютсяРаботыСДосрочнойПенсией", УчетЗарплаты.ИспользуютсяРаботыСДосрочнойПенсией());
	КонецЕсли;
	Если ПроверяемыеОпцииПодсистемы.УдерживаютсяДобровольныеВзносыВПФР Тогда
		ВключаемыеОпцииПодсистемы.Вставить("УдерживаютсяДобровольныеВзносыВПФР", Ложь);
	Иначе
		ВключаемыеОпцииПодсистемы.Вставить("УдерживаютсяДобровольныеВзносыВПФР", УчетЗарплаты.УдерживаютсяДобровольныеВзносыВПФР());
	КонецЕсли;
	
	Возврат ВключаемыеОпцииПодсистемы;
	
КонецФункции

#КонецОбласти

#Область ПроверкиАктуальности

Процедура ПроверитьАктуальностьПолучателя(ДанныеОбъекта, РезультатПроверки) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДанныеОбъекта.Налог)
		ИЛИ ДанныеОбъекта.Налог = Справочники.ВидыНалоговИПлатежейВБюджет.ПрочиеНалогиИСборы Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДанныеОбъекта.Контрагент) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеНалога = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеОбъекта.Налог, "Наименование, ВидНалога, КодБК");
	НеактуальныеНалоги = ПлатежиВБюджетКлиентСерверПереопределяемый.НеактуальныеНалоги(ДанныеОбъекта.Дата);
	Если НеактуальныеНалоги[ДанныеНалога.ВидНалога] <> Неопределено
		И НЕ НеактуальныеНалоги[ДанныеНалога.ВидНалога].Свойство("АктуальныйНалог") Тогда
		ПолучательИзДокумента = ДанныеОбъекта.Контрагент;
		АктуальныйПолучатель  = ДанныеГосударственныхОрганов.АдминистраторНалогаОрганизации(
			ДанныеОбъекта.Налог, ДанныеОбъекта.Организация, ДанныеОбъекта.Дата);
		
		ДанныеКонтрагента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеОбъекта.Контрагент,
			"ГосударственныйОрган, ВидГосударственногоОргана");
		Если ЗначениеЗаполнено(АктуальныйПолучатель) И ДанныеОбъекта.Контрагент <> АктуальныйПолучатель
			И ДанныеКонтрагента.ГосударственныйОрган
			И ДанныеКонтрагента.ВидГосударственногоОргана <> Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган Тогда
			ШаблонОшибки = НСтр("ru = 'Возможно, неверно указан получатель платежа %1.
				|С %2 %3 уплачивается в Федеральную налоговую службу.
				|Для вашей организации это %4.'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки,
				ДанныеОбъекта.Контрагент,
				Формат(НеактуальныеНалоги[ДанныеНалога.ВидНалога].ДатаНеактуальности, "ДЛФ=DD"),
				ДанныеНалога.Наименование,
				АктуальныйПолучатель);
			
			ОписаниеОшибки = ПлатежиВБюджетКлиентСервер.НовыйОписаниеОшибки(ТекстОшибки, "Контрагент");
			РезультатПроверки.Ошибки.Добавить(ОписаниеОшибки);
		Иначе
			Если ДанныеКонтрагента.ГосударственныйОрган
				И ДанныеКонтрагента.ВидГосударственногоОргана <> Перечисления.ВидыГосударственныхОрганов.НалоговыйОрган
				И ПлатежиВБюджетКлиентСервер.ПлатежАдминистрируетсяНалоговымиОрганами(ДанныеНалога.КодБК) Тогда
				ШаблонОшибки = НСтр("ru = 'Возможно, неверно указан получатель платежа %1.
					|%2 уплачивается в Федеральную налоговую службу.'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки,
					ДанныеОбъекта.Контрагент, ДанныеНалога.Наименование);
				
				ОписаниеОшибки = ПлатежиВБюджетКлиентСервер.НовыйОписаниеОшибки(ТекстОшибки, "Контрагент");
				РезультатПроверки.Ошибки.Добавить(ОписаниеОшибки);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьАктуальностьНалога(ДанныеОбъекта, РезультатПроверки) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ДанныеОбъекта.Налог)
		ИЛИ ДанныеОбъекта.Налог = Справочники.ВидыНалоговИПлатежейВБюджет.ПрочиеНалогиИСборы Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеНалога = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеОбъекта.Налог, "Наименование, ВидНалога");
	НеактуальныеНалоги = ПлатежиВБюджетКлиентСерверПереопределяемый.НеактуальныеНалоги(ДанныеОбъекта.Дата);
	Если НеактуальныеНалоги[ДанныеНалога.ВидНалога] <> Неопределено
		И НеактуальныеНалоги[ДанныеНалога.ВидНалога].Свойство("АктуальныйНалог") Тогда
		НазваниеАктуальногоНалога = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
			Справочники.ВидыНалоговИПлатежейВБюджет.НалогПоВиду(НеактуальныеНалоги[ДанныеНалога.ВидНалога].АктуальныйНалог),
			"Наименование");
		ШаблонОшибки = НСтр("ru = '%1 не применяется с %2
			|Следует использовать %3.'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонОшибки,
			ДанныеНалога.Наименование,
			Формат(НеактуальныеНалоги[ДанныеНалога.ВидНалога].ДатаНеактуальности, "ДЛФ=DD"),
			НазваниеАктуальногоНалога);
		
		ОписаниеОшибки = ПлатежиВБюджетКлиентСервер.НовыйОписаниеОшибки(ТекстОшибки, "Налог");
		РезультатПроверки.Ошибки.Добавить(ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииВидовНалогов

Функция ТаблицаСоответствияСчетовУчета()
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ВидНалога", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыНалогов"));
	ТаблицаЗначений.Колонки.Добавить("СчетУчета", Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НДФЛ, ПланыСчетов.Хозрасчетный.НДФЛ);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НДС, ПланыСчетов.Хозрасчетный.НДС);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НДС, ПланыСчетов.Хозрасчетный.НДСНалоговогоАгента);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НДС_ВвозимыеТовары, ПланыСчетов.Хозрасчетный.НДСТаможенныйСоюзКУплате);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет,  ПланыСчетов.Хозрасчетный.РасчетыСБюджетом);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет, ПланыСчетов.Хозрасчетный.РасчетыСБюджетом);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрибыль_НалоговыйАгент, ПланыСчетов.Хозрасчетный.НалогНаПрибыльНалоговогоАгента);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход, ПланыСчетов.Хозрасчетный.ПрочиеНалогиИСборы);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородФедеральногоЗначения,              ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкруг,                         ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкругСВнутригородскимДелением, ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ВнутригородскойОкруг,                   ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_МежселеннаяТерритория,                  ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_СельскоеПоселение,                      ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскоеПоселение,                     ПланыСчетов.Хозрасчетный.ЗемельныйНалог);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ТранспортныйНалог, ПланыСчетов.Хозрасчетный.ТранспортныйНалог);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ТорговыйСбор, ПланыСчетов.Хозрасчетный.ТорговыйСбор);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаИмущество,     ПланыСчетов.Хозрасчетный.НалогНаИмущество);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаИмуществоЕСГС, ПланыСчетов.Хозрасчетный.НалогНаИмущество);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЕНВД, ПланыСчетов.Хозрасчетный.ЕНВД);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.УСН_Доходы,             ПланыСчетов.Хозрасчетный.ЕНприУСН);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы, ПланыСчетов.Хозрасчетный.ЕНприУСН);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.УСН_МинимальныйНалог,   ПланыСчетов.Хозрасчетный.ЕНприУСН);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НДФЛ_ИП,      ПланыСчетов.Хозрасчетный.НДФЛ_ИП);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.НДФЛ_ФизЛицо, ПланыСчетов.Хозрасчетный.ПрибыльПодлежащаяРаспределению);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ВнутригородскойРайон,                   ПланыСчетов.Хозрасчетный.НалогПриПСН);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ГородскойОкруг,                         ПланыСчетов.Хозрасчетный.НалогПриПСН);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ГородскойОкругСВнутригородскимДелением, ПланыСчетов.Хозрасчетный.НалогПриПСН);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ГородФедеральногоЗначения,              ПланыСчетов.Хозрасчетный.НалогПриПСН);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_МуниципальныйРайон,                     ПланыСчетов.Хозрасчетный.НалогПриПСН);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ЕСХН, ПланыСчетов.Хозрасчетный.ПрочиеНалогиИСборы);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть,      ПланыСчетов.Хозрасчетный.ПФР_ОПС);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть,      ПланыСчетов.Хозрасчетный.ПФР_страх);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_НакопительнаяЧасть,  ПланыСчетов.Хозрасчетный.ПФР_нак);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ФФОМС,                   ПланыСчетов.Хозрасчетный.ФФОМС);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС,                     ПланыСчетов.Хозрасчетный.ФСС);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС_НСиПЗ,               ПланыСчетов.Хозрасчетный.ФСС_НСиПЗ);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ЛетныеЭкипажи,  ПланыСчетов.Хозрасчетный.ПФР_доп);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_Шахтеры,        ПланыСчетов.Хозрасчетный.ПФР_доп_шахтеры);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ВредныеУсловия, ПланыСчетов.Хозрасчетный.ПФР_доп_ВредныеУсловияТруда);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ТяжелыеУсловия, ПланыСчетов.Хозрасчетный.ПФР_доп_ТяжелыеУсловияТруда);
	
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть,     ПланыСчетов.Хозрасчетный.ПФР_ОПС_ИП);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть,     ПланыСчетов.Хозрасчетный.ПФР_Страх_СтраховойГод);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_НакопительнаяЧасть, ПланыСчетов.Хозрасчетный.ПФР_Нак_СтраховойГод);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ФФОМС,                  ПланыСчетов.Хозрасчетный.ФОМС_СтраховойГод);
	ДобавитьСчетУчета(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ФСС,                    ПланыСчетов.Хозрасчетный.ФСС_СтраховойГод);
	
	Возврат ТаблицаЗначений;
	
КонецФункции

Процедура ДобавитьСчетУчета(ТаблицаЗначений, ВидНалога, СчетУчета)
	
	НоваяСтрока = ТаблицаЗначений.Добавить();
	НоваяСтрока.ВидНалога = ВидНалога;
	НоваяСтрока.СчетУчета = СчетУчета;
	
КонецПроцедуры

Функция ТаблицаСоответствияЗадачБухгалтера() Экспорт
	
	ТаблицаЗначений = Новый ТаблицаЗначений;
	ТаблицаЗначений.Колонки.Добавить("ВидНалога", Новый ОписаниеТипов("ПеречислениеСсылка.ВидыНалогов"));
	ТаблицаЗначений.Колонки.Добавить("КодЗадачи", ОбщегоНазначения.ОписаниеТипаСтрока(100));
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НДС, "НДС");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НДС_ВвозимыеТовары, "КосвенныеНалогиТамСоюз");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрибыль_ФедеральныйБюджет,  "НалогНаПрибыль");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрибыль_РегиональныйБюджет, "НалогНаПрибыль");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаПрофессиональныйДоход, "НалогНаПрофессиональныйДоход");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородФедеральногоЗначения,              "ЗемельныйНалог");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкруг,                         "ЗемельныйНалог");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскойОкругСВнутригородскимДелением, "ЗемельныйНалог");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ВнутригородскойОкруг,                   "ЗемельныйНалог");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_МежселеннаяТерритория,                  "ЗемельныйНалог");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_СельскоеПоселение,                      "ЗемельныйНалог");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЗемельныйНалог_ГородскоеПоселение,                     "ЗемельныйНалог");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ТранспортныйНалог, "ТранспортныйНалог");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ТорговыйСбор, "ТорговыйСбор");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаИмущество,     "НалогНаИмущество");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НалогНаИмуществоЕСГС, "НалогНаИмущество");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЕНВД, "ЕНВД");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.УСН_Доходы,             "УСН");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.УСН_ДоходыМинусРасходы, "УСН");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.УСН_МинимальныйНалог,   "УСН");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НДФЛ_ИП,      "НДФЛ_Предприниматель");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НДФЛ_ФизЛицо, "НДФЛ_Предприниматель");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ВнутригородскойРайон,                   "НалогПриПСН");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ГородскойОкруг,                         "НалогПриПСН");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ГородскойОкругСВнутригородскимДелением, "НалогПриПСН");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_ГородФедеральногоЗначения,              "НалогПриПСН");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ПСН_МуниципальныйРайон,                     "НалогПриПСН");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ЕСХН, "ЕСХН");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть,      "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_НакопительнаяЧасть,  "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ПФР_Добровольные,        "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ФФОМС,                   "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС,                     "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.СтраховыеВзносы_ФСС_НСиПЗ,               "СтраховыеВзносы");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ЛетныеЭкипажи,  "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_Шахтеры,        "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ВредныеУсловия, "СтраховыеВзносы");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ДополнительныеВзносы_ПФР_ТяжелыеУсловия, "СтраховыеВзносы");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_НакопительнаяЧасть, "СтраховыеВзносы_Предприниматель");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть,     "СтраховыеВзносы_Предприниматель");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ФФОМС,                  "СтраховыеВзносы_Предприниматель");
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.ФиксированныеВзносы_ФСС,                    "СтраховыеВзносы_Предприниматель");
	
	ДобавитьКодЗадачи(ТаблицаЗначений, Перечисления.ВидыНалогов.НДФЛ, "НДФЛ_Агент_Уплата");
	
	Возврат ТаблицаЗначений;
	
КонецФункции

Процедура ДобавитьКодЗадачи(ТаблицаЗначений, ВидНалога, КодЗадачи)
	
	НоваяСтрока = ТаблицаЗначений.Добавить();
	НоваяСтрока.ВидНалога = ВидНалога;
	НоваяСтрока.КодЗадачи = КодЗадачи;
	
КонецПроцедуры

// Функция ищет подходящий вид налога по составу элементов справочника ВидыНалоговИПлатежейВБюджет.
// Применяется в тех случаях, когда условию поиска соответствовует несколько элементов перечисления ВидыНалогов.
//
Функция ПрименяемыйВидНалога(ВидыНалогов, СчетУчета = Неопределено)
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	1 КАК Приоритет,
		|	ВидыНалоговИПлатежейВБюджет.ВидНалога
		|ИЗ
		|	Справочник.ВидыНалоговИПлатежейВБюджет КАК ВидыНалоговИПлатежейВБюджет
		|ГДЕ
		|	ВидыНалоговИПлатежейВБюджет.ВидНалога В(&ВидыНалогов)
		|	И &УсловиеПоВидуНалога";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ВидыНалогов", ВидыНалогов);
	Запрос.УстановитьПараметр("СчетУчета",   СчетУчета);
	
	Запрос.Текст = СтрЗаменить(ТекстЗапроса, 
		"&УсловиеПоВидуНалога",
		?(ЗначениеЗаполнено(СчетУчета), "ВидыНалоговИПлатежейВБюджет.СчетУчета = &СчетУчета", "ИСТИНА"));
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		Выборка.Следующий();
		ВидНалога = Выборка.ВидНалога;
	Иначе
		ВидНалога = Перечисления.ВидыНалогов.ПустаяСсылка();
	КонецЕсли;
	
	Возврат ВидНалога;
	
КонецФункции

#КонецОбласти

#КонецЕсли
