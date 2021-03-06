#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
                            		 
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
//
// Параметры:
//  ПараметрОбъектКопирования - ДокументОбъект.
//
Процедура ПервоначальноеЗаполнениеДокумента(ПараметрОбъектКопирования = Неопределено)
	
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект
												,ПользователиКлиентСервер.ТекущийПользователь()
												,ПараметрОбъектКопирования);
	
КонецПроцедуры // ПервоначальноеЗаполнениеДокумента()
											
// Процедура выполняет первоначальное заполнение созданного/скопированного документа.
//
// Параметры:
//  СтруктураШапкиДокумента - Структура
//  СтруктураТаблиц         - Структура
//  Отказ            		- Булево
//  Заголовок 				- Строка
//
Процедура ПроверкаДанных(Отказ)
	
КонецПроцедуры // ПроверкаДанных()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Процедура выполняет движения по регистрам.
//
Процедура ДвиженияПоРегистрам(Отказ)
	
	ДвиженияМСФО	= Движения.бит_Дополнительный_2;
	
	Для Каждого СтрокаБаза Из База Цикл
		
		Если СтрокаБаза.Сумма = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Движение = ДвиженияМСФО.Добавить();
		Движение.Период 	 		= КонецДня(Дата);
		Движение.Организация 		= СтрокаБаза.Организация;
		
		Движение.СчетДт 			= СтрокаБаза.Счет;
		рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Объект",  СтрокаБаза.Объект);
		рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Функции",  СтрокаБаза.ФункцияЦФО);
		рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетДт, Движение.СубконтоДт, "Периоды",  СтрокаБаза.Период);
		
		Движение.СчетКт 			= рс_ОбщийМодуль.ПолучитьНастройкуЭкономическогоУчета(Справочники.рс_ПоказателиНастроекЭУ.СчетУчетаЗадолженностиПоАккруалам, Дата);
		рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "Контрагенты", Справочники.Контрагенты.НайтиПоНаименованию(СтрокаБаза.ПредполагаемыйКонтрагент));
		//рс_ОбщийМодуль.УстановитьСубконто(Движение.СчетКт, Движение.СубконтоКт, "ДоговорыКонтрагентов",  ДоговорКонтрагента);
		
		Движение.СуммаМУ			= СтрокаБаза.Сумма;
		Движение.СуммаРегл			= СтрокаБаза.Сумма;
		Движение.СуммаУпр			= СтрокаБаза.Сумма;
		Движение.ВидДвиженияМСФО	= Перечисления.БИТ_ВидыДвиженияМСФО.Аккруал;
		Движение.Содержание 		= СокрЛП(СтрокаБаза.ЦельРасходов);
		
		/////////////////////////////////////////////////
		ДвижениеСторно = ДвиженияМСФО.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеСторно, Движение);
		
		ДвижениеСторно.Период 	 		= НачалоДня(ДатаСторно);
		
		Для Каждого КлючИЗначение Из Движение.СубконтоДт Цикл
			ДвижениеСторно.СубконтоДт[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
		Для Каждого КлючИЗначение Из Движение.СубконтоКт Цикл
			ДвижениеСторно.СубконтоКт[КлючИЗначение.Ключ] = КлючИЗначение.Значение;
		КонецЦикла;
		
		ДвижениеСторно.СуммаМУ			= - Движение.СуммаМУ;
		ДвижениеСторно.СуммаРегл		= - Движение.СуммаРегл;
		ДвижениеСторно.СуммаУпр			= - Движение.СуммаУпр;
		ДвижениеСторно.ВидДвиженияМСФО	= Перечисления.БИТ_ВидыДвиженияМСФО.СторноАккруала;
		
	КонецЦикла;
	
КонецПроцедуры // ДвиженияПоРегистрам()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события "ПриКопировании"
//
Процедура ПриКопировании(ОбъектКопирования)
	
	ПервоначальноеЗаполнениеДокумента(ОбъектКопирования);
	
КонецПроцедуры // ПриКопировании()

// Процедура - обработчик события "ПередЗаписью".
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
	КонецЕсли;
	 	
	ТаблицаБаза = База.Выгрузить();
	ТаблицаБаза.Свернуть("Организация");
	
	Если ТаблицаБаза.Количество() = 1 Тогда
		Организация = ТаблицаБаза[0].Организация;
	Иначе
		Организация = Неопределено;
	КонецЕсли;
	
	ТаблицаБаза = База.Выгрузить();
	ТаблицаБаза.Свернуть("Счет");
	
	Если ТаблицаБаза.Количество() = 1 Тогда
		Счет = ТаблицаБаза[0].Счет;
	Иначе
		Счет = Неопределено;
	КонецЕсли;
	
	ТаблицаБаза = База.Выгрузить();
	ТаблицаБаза.Свернуть("ПредполагаемыйКонтрагент");
	
	Если ТаблицаБаза.Количество() = 1 Тогда
		ПредполагаемыйКонтрагент = ТаблицаБаза[0].ПредполагаемыйКонтрагент;
	Иначе
		ПредполагаемыйКонтрагент = Неопределено;
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-06-25 (#3788)
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ок_СозданОбработкой Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	АккруалБезIDБаза.Ссылка КАК Документ,
		|	АккруалБезIDБаза.ИДСтроки КАК ИДСтроки,
		|	АккруалБезIDБаза.Ссылка.ок_Кампания КАК Кампания,
		|	АккруалБезIDБаза.Объект КАК Объект,
		|	АккруалБезIDБаза.ФункцияЦФО КАК ЦФО,
		|	АккруалБезIDБаза.Период.Дата КАК ПериодКЗБ,
		|	АккруалБезIDБаза.СтатьяОборотов КАК СтатьяОборотов,
		|	АккруалБезIDБаза.Сумма КАК НачислитьАккруал,
		|	АккруалБезIDБаза.НомерЗаявки КАК ФВБ,
		|	ВЫБОР
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-11-19 (#3966)
		//|		КОГДА АккруалБезIDБаза.Объект <> НачислениеАккруаловМСФО.Объект
		//|				ИЛИ АккруалБезIDБаза.ФункцияЦФО <> НачислениеАккруаловМСФО.ЦФО
		//|				ИЛИ АккруалБезIDБаза.Период <> НачислениеАккруаловМСФО.ПериодКЗБ
		//|				ИЛИ АккруалБезIDБаза.СтатьяОборотов <> НачислениеАккруаловМСФО.СтатьяОборотов
		//|				ИЛИ АккруалБезIDБаза.Сумма <> НачислениеАккруаловМСФО.НачислитьАккруал
		//|				ИЛИ АккруалБезIDБаза.НомерЗаявки <> НачислениеАккруаловМСФО.ФВБ
		|		КОГДА (АккруалБезIDБаза.Объект <> НачислениеАккруаловМСФО.Объект
		|				ИЛИ АккруалБезIDБаза.ФункцияЦФО <> НачислениеАккруаловМСФО.ЦФО
		|				ИЛИ АккруалБезIDБаза.Период <> НачислениеАккруаловМСФО.ПериодКЗБ
		|				ИЛИ АккруалБезIDБаза.СтатьяОборотов <> НачислениеАккруаловМСФО.СтатьяОборотов
		|				ИЛИ АккруалБезIDБаза.Сумма <> НачислениеАккруаловМСФО.НачислитьАккруал
		|				ИЛИ АккруалБезIDБаза.НомерЗаявки <> НачислениеАккруаловМСФО.ФВБ)
		|				И АккруалБезIDБаза.Сумма > 0
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-11-19 (#3966)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ФормироватьЗаписьВРСНачислениеАккруаловМСФО
		|ИЗ
		|	Документ.рс_АккруалБезID.База КАК АккруалБезIDБаза
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу.СрезПоследних КАК СоответствиеИДСтрокДокументу_ПоследнийДокумент
		|		ПО АккруалБезIDБаза.ИДСтроки = СоответствиеИДСтрокДокументу_ПоследнийДокумент.ИДСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу.СрезПоследних(, Документ = &Ссылка) КАК СоответствиеИДСтрокДокументу_ТекущийДокумент
		|		ПО АккруалБезIDБаза.ИДСтроки = СоответствиеИДСтрокДокументу_ТекущийДокумент.ИДСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_НачислениеАккруаловМСФО КАК НачислениеАккруаловМСФО
		|		ПО АккруалБезIDБаза.ИДСтроки = НачислениеАккруаловМСФО.ИДСтроки
		|			И АккруалБезIDБаза.Ссылка.ок_Кампания = НачислениеАккруаловМСФО.Кампания
		|ГДЕ
		|	АккруалБезIDБаза.Ссылка = &Ссылка
		|	И (СоответствиеИДСтрокДокументу_ПоследнийДокумент.Документ = &Ссылка
		|			ИЛИ СоответствиеИДСтрокДокументу_ТекущийДокумент.Документ ЕСТЬ NULL)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-10-19 (#3914)
	//РезультатЗапроса = Запрос.Выполнить();
	//ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	
	//	Если ВыборкаДетальныеЗаписи.ФормироватьЗаписьВРСНачислениеАккруаловМСФО Тогда
	//	
	//		НаборЗаписей = РегистрыСведений.ок_НачислениеАккруаловМСФО.СоздатьНаборЗаписей();
	//		НаборЗаписей.Отбор.ИДСтроки.Установить(ВыборкаДетальныеЗаписи.ИДСтроки);
	//		НаборЗаписей.Отбор.Кампания.Установить(ВыборкаДетальныеЗаписи.Кампания);
	//		НаборЗаписей.Прочитать();
	//		
	//		Если НаборЗаписей.Количество() > 0 Тогда
	//			
	//			ТекущаяЗапись = НаборЗаписей[0];
	//			
	//			ЗаполнитьЗначенияСвойств(ТекущаяЗапись, ВыборкаДетальныеЗаписи);
	//			ТекущаяЗапись.ДатаИзменения = ТекущаяДата();
	//			ТекущаяЗапись.Ответственный = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
	//			
	//			НаборЗаписей.Записать();
	//			
	//		Иначе
	//			
	//			ТекущаяЗапись = НаборЗаписей.Добавить();
	//			
	//			ЗаполнитьЗначенияСвойств(ТекущаяЗапись, ВыборкаДетальныеЗаписи);
	//			ТекущаяЗапись.ДатаИзменения = ТекущаяДата();
	//			ТекущаяЗапись.Ответственный = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
	//			
	//			НаборЗаписей.Записать();
	//			
	//		КонецЕсли;
	//	
	//	КонецЕсли; 
	//	
	//	НаборЗаписей = РегистрыСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу.СоздатьНаборЗаписей();
	//	НаборЗаписей.Отбор.ИДСтроки.Установить(ВыборкаДетальныеЗаписи.ИДСтроки);
	//	НаборЗаписей.Отбор.Кампания.Установить(ВыборкаДетальныеЗаписи.Кампания);
	//	НаборЗаписей.Отбор.Период.Установить(ТекущаяДата());
	//	
	//	ТекущаяЗапись = НаборЗаписей.Добавить();
	//		
	//	ТекущаяЗапись.Период 	= ТекущаяДата();
	//	ТекущаяЗапись.Документ 	= ВыборкаДетальныеЗаписи.Документ;
	//	ТекущаяЗапись.Кампания 	= ВыборкаДетальныеЗаписи.Кампания;
	//	ТекущаяЗапись.ИДСтроки 	= ВыборкаДетальныеЗаписи.ИДСтроки;
	//	
	//	НаборЗаписей.Записать();
	//	
	//КонецЦикла;
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаРезультата = РезультатЗапроса.Выгрузить();
	
	ПараметрыОтбора = Новый Структура();
	ПараметрыОтбора.Вставить("ФормироватьЗаписьВРСНачислениеАккруаловМСФО", Истина);
	
	ТаблицаДляЗаписиРСНачислениеАккруаловМСФО 			= ТаблицаРезультата.Скопировать(ПараметрыОтбора);
	МассивИДСтрокиДляЗаписиРСНачислениеАккруаловМСФО	= ТаблицаДляЗаписиРСНачислениеАккруаловМСФО.ВыгрузитьКолонку("ИДСтроки");
	
	ДатаИзменения = ТекущаяДата();
	Ответственный = бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь");
	
	//Обновить записи в МСФО
	НаборЗаписейМСФО = РегистрыСведений.ок_НачислениеАккруаловМСФО.СоздатьНаборЗаписей();
	НаборЗаписейМСФО.Отбор.Кампания.Установить(ок_Кампания);
	НаборЗаписейМСФО.Прочитать();
	
	Для каждого СтрокаНабораЗаписей Из НаборЗаписейМСФО Цикл
		
		Если МассивИДСтрокиДляЗаписиРСНачислениеАккруаловМСФО.Найти(СтрокаНабораЗаписей.ИДСтроки) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		НайденнаяСтрока = ТаблицаДляЗаписиРСНачислениеАккруаловМСФО.Найти(СтрокаНабораЗаписей.ИДСтроки, "ИДСтроки");
		
		ЗаполнитьЗначенияСвойств(СтрокаНабораЗаписей, НайденнаяСтрока);
		СтрокаНабораЗаписей.ДатаИзменения = ДатаИзменения;
		СтрокаНабораЗаписей.Ответственный = Ответственный;
		
		МассивИДСтрокиДляЗаписиРСНачислениеАккруаловМСФО.Удалить(МассивИДСтрокиДляЗаписиРСНачислениеАккруаловМСФО.Найти(СтрокаНабораЗаписей.ИДСтроки));
		ТаблицаДляЗаписиРСНачислениеАккруаловМСФО.Удалить(НайденнаяСтрока);
		
	КонецЦикла; 
	
	Для каждого ВыборкаДетальныеЗаписи Из ТаблицаДляЗаписиРСНачислениеАккруаловМСФО Цикл
	
		СтрокаНабораЗаписей = НаборЗаписейМСФО.Добавить();
				
		ЗаполнитьЗначенияСвойств(СтрокаНабораЗаписей, ВыборкаДетальныеЗаписи);
		СтрокаНабораЗаписей.ДатаИзменения = ДатаИзменения;
		СтрокаНабораЗаписей.Ответственный = Ответственный;
	
	КонецЦикла; 
		
	НаборЗаписейМСФО.Записать();
	
	//Зафиксировать соответствие ИД строк документу 
	НаборЗаписейНачислениеАккруаловСоответствиеИДСтрокДокументу = РегистрыСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу.СоздатьНаборЗаписей();
	НаборЗаписейНачислениеАккруаловСоответствиеИДСтрокДокументу.Отбор.Кампания.Установить(ок_Кампания);
	НаборЗаписейНачислениеАккруаловСоответствиеИДСтрокДокументу.Отбор.Период.Установить(ДатаИзменения);
	
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-11-19 (#3966)
	ТаблицаРезультата = ТаблицаРезультата.Скопировать(,"Документ, Кампания, ИДСтроки");
	ТаблицаРезультата.Свернуть("Документ, Кампания, ИДСтроки");
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-11-19 (#3966)
	
	Для каждого ВыборкаДетальныеЗаписи Из ТаблицаРезультата Цикл
		
		ТекущаяЗапись = НаборЗаписейНачислениеАккруаловСоответствиеИДСтрокДокументу.Добавить();
			
		ТекущаяЗапись.Период 	= ДатаИзменения;
		ТекущаяЗапись.Документ 	= ВыборкаДетальныеЗаписи.Документ;
		ТекущаяЗапись.Кампания 	= ВыборкаДетальныеЗаписи.Кампания;
		ТекущаяЗапись.ИДСтроки 	= ВыборкаДетальныеЗаписи.ИДСтроки;
		
	КонецЦикла; 

	НаборЗаписейНачислениеАккруаловСоответствиеИДСтрокДокументу.Записать();
	//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-10-19 (#3914)
	
	//Удалить из регистра удаленные в документе строки
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.Кампания КАК Кампания,
		|	НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.ИДСтроки КАК ИДСтроки,
		|	НЕ НачислениеАккруаловСоответствиеИДСтрокДокументу_ДругиеДокументы.Документ ЕСТЬ NULL КАК УдалитьЗаписьМСФО
		|ИЗ
		|	РегистрСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу КАК НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.рс_АккруалБезID.База КАК рс_АккруалБезIDБаза
		|		ПО НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.Документ = рс_АккруалБезIDБаза.Ссылка
		|			И НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.ИДСтроки = рс_АккруалБезIDБаза.ИДСтроки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу КАК НачислениеАккруаловСоответствиеИДСтрокДокументу_ДругиеДокументы
		|		ПО (НачислениеАккруаловСоответствиеИДСтрокДокументу_ДругиеДокументы.Документ <> НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.Документ)
		|			И (НачислениеАккруаловСоответствиеИДСтрокДокументу_ДругиеДокументы.ИДСтроки = НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.ИДСтроки)
		|ГДЕ
		|	НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.Кампания = &Кампания
		|	И НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.Документ = &Документ
		|	И рс_АккруалБезIDБаза.ИДСтроки ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.ИДСтроки,
		|	НЕ НачислениеАккруаловСоответствиеИДСтрокДокументу_ДругиеДокументы.Документ ЕСТЬ NULL,
		|	НачислениеАккруаловСоответствиеИДСтрокДокументу_ТекущийДокумент.Кампания";
	
	Запрос.УстановитьПараметр("Документ", Ссылка);
	Запрос.УстановитьПараметр("Кампания", ок_Кампания);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ок_НачислениеАккруаловСоответствиеИДСтрокДокументу.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ИДСтроки.Установить(ВыборкаДетальныеЗаписи.ИДСтроки);
		НаборЗаписей.Отбор.Кампания.Установить(ВыборкаДетальныеЗаписи.Кампания);
		НаборЗаписей.Записать();
		
		Если ВыборкаДетальныеЗаписи.УдалитьЗаписьМСФО Тогда
		
			НаборЗаписей = РегистрыСведений.ок_НачислениеАккруаловМСФО.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.ИДСтроки.Установить(ВыборкаДетальныеЗаписи.ИДСтроки);
			НаборЗаписей.Отбор.Кампания.Установить(ВыборкаДетальныеЗаписи.Кампания);
			НаборЗаписей.Записать();
		
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-06-25 (#3788)

// Процедура - обработчик события "ОбработкаПроведения".
//
Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Проверка данных
	ПроверкаДанных(Отказ);
	
	// Проведение
	Если Не Отказ Тогда
		ДвиженияПоРегистрам(Отказ);
	КонецЕсли; 

КонецПроцедуры // ОбработкаПроведения()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
КонецПроцедуры

#КонецЕсли