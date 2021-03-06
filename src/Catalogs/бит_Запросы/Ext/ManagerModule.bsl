#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныйПрограммныйИнтерфейс
	
// Устарело, следует использовать ОбновитьПриПереходеНаНовыйРелиз(). 
Процедура ОбновитьПредопределенныеЗапросы(Знач Макет = Неопределено, РежимСообщений = "Все") Экспорт
	
	ОбновитьПриПереходеНаНовыйРелиз();
	
КонецПроцедуры

Процедура ОбновитьПриПереходеНаНовыйРелиз() Экспорт

	Если ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда // В подчиненных узлах РИБ не выполняется
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	бит_Запросы.ИмяПредопределенныхДанных КАК ИмяПредопределенныхДанных,
	|	бит_Запросы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.бит_Запросы КАК бит_Запросы";

	ТаблицаСправочника = Запрос.Выполнить().Выгрузить();
	ТаблицаСправочника.Индексы.Добавить("ИмяПредопределенныхДанных");
	
	Макет = Справочники.бит_Запросы.ПолучитьМакет("ПоставляемыеЗапросы");	
	ТаблицаШаблонов = ОбщегоНазначения.ЗначениеИзСтрокиXML(Макет.ПолучитьТекст());
	
	Для Каждого СтрокаТаблицы Из ТаблицаШаблонов Цикл
		
		НайденнаяСтрока = ТаблицаСправочника.Найти(СтрокаТаблицы.ИмяПредопределенныхДанных, "ИмяПредопределенныхДанных");
		Если НайденнаяСтрока <> Неопределено Тогда
			Объект = НайденнаяСтрока.Ссылка.ПолучитьОбъект();
			ЗаполнитьЗначенияСвойств(Объект, СтрокаТаблицы);
			Объект.ВидИнформационнойБазы = Справочники.бит_мпд_ВидыИнформационныхБаз.ТекущаяИнформационнаяБаза;
			ОбновлениеИнформационнойБазы.ЗаписатьОбъект(Объект, Истина);
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры
 
// Функция определяет является данный запрос - запросом на внутреннем языке 1С.
// 
// Параметры:
//  ЗапросСсылка - СправочникСсылка.бит_Запросы.
// 
// Возвращаемое значение:
//  Результат - Строка.
// 
Функция ЭтоОбычныйЗапрос(ЗапросСсылка) Экспорт

	флОбычный = ?(ЗапросСсылка.Вид = Перечисления.бит_мпд_ВидыЗапросов.Запрос1С 
	              ИЛИ НЕ ЗначениеЗаполнено(ЗапросСсылка.Вид), Истина, Ложь);
	

	Возврат флОбычный;
	
КонецФункции // ЭтоОбычныйЗапрос()

// Функция получает структуру метаданных целевой внешней базы по HTTP.
// 
// Параметры:
//  ЗапросСсылка - СправочникСсылка.бит_Запросы.
// 
// Возвращаемое значение:
//  СтрОтвет - Строка.
// 
Функция ПолучитьМетаданныеHTTP(ЗапросСсылка)
	
	НастройкаПодключения = ЗапросСсылка.ВидИнформационнойБазы.НастройкаПодключенияПоУмолчанию;
	ОтветHTTP = бит_мпд_ПовтИсп.ПолучитьМетаданныеHTTP(НастройкаПодключения, Истина);
	СтрОтвет = ОтветHTTP.ПолучитьТелоКакСтроку();
	
	Возврат СтрОтвет;
	
КонецФункции // ПолучитьМетаданныеHTTP()

// Функция получает доступные HTTP запросы.
// 
// Параметры:
//   ЗапросСсылка - СправочникСсылка.бит_Запросы.
// 
// Возвращаемое значение:
//  РезСтруктура - Структура.
// 
Функция ПолучитьДоступныеЗапросыHTTP(ЗапросСсылка) Экспорт
	
	РезСтруктура = Новый Структура;
	
	ПризнакОбращения = бит_мпд_КлиентСервер.ПризнакОбращенияОДата();
	
	// Инициализация дерева выбора
	ДеревоВыбора = Новый ДеревоЗначений;
	ОписаниеТиповСтрока = Новый ОписаниеТипов("Строка");
	ДеревоВыбора.Колонки.Добавить("Значение"     , ОписаниеТиповСтрока);
	ДеревоВыбора.Колонки.Добавить("Представление", ОписаниеТиповСтрока);
	ДеревоВыбора.Колонки.Добавить("Картинка"     , Новый ОписаниеТипов("Картинка"));
	ДеревоВыбора.Колонки.Добавить("Уровень"		 , Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1)));
	
	// СтрокаРС = ДеревоВыбора.Строки.Добавить();
	// СтрокаРС.Значение = "РегистрыСведений";
	// СтрокаРС.Представление =  НСтр("ru = 'Регистры сведений'");
	// СтрокаРС.Картинка = БиблиотекаКартинок.РегистрСведений;
	// СтрокаРС.Уровень = 0;
	
	СтрокаРН = ДеревоВыбора.Строки.Добавить();
	СтрокаРН.Значение = "РегистрыНакопления";
	СтрокаРН.Представление =  НСтр("ru = 'Регистры накопления'");
	СтрокаРН.Картинка = БиблиотекаКартинок.РегистрНакопления;
	СтрокаРН.Уровень = 0;
	
	СтрокаРБ = ДеревоВыбора.Строки.Добавить();
	СтрокаРБ.Значение = "РегистрыБухгалтерии";
	СтрокаРБ.Представление =  НСтр("ru = 'Регистры бухгалтерии'");
	СтрокаРБ.Картинка = БиблиотекаКартинок.РегистрБухгалтерии;
	СтрокаРБ.Уровень = 0;
	
	Отказ = Ложь;
	
	Если НЕ ЗначениеЗаполнено(ЗапросСсылка.ВидИнформационнойБазы.НастройкаПодключенияПоУмолчанию) Тогда
		
		ТекстСообщения =  НСтр("ru = 'Для вида информационной базы не заполнены параметры подключения по-умолчанию!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		
		Отказ = Истина;
		
	КонецЕсли; 
	
	Если НЕ Отказ Тогда
		
		СтрОтвет = ПолучитьМетаданныеHTTP(ЗапросСсылка);
		
		Чтение = Новый ЧтениеXML;
		Чтение.УстановитьСтроку(СтрОтвет);
		
		Пока Чтение.Прочитать() Цикл
		
			Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
				 И Чтение.Имя = "FunctionImport" 
				 И Чтение.КоличествоАтрибутов() > 0 Тогда
			
				 ИмяФункции = Чтение.ПолучитьАтрибут("Name");
				 Выражение = Чтение.ПолучитьАтрибут("ReturnType");
				 
				 // Выделим имя регистра
				 Выражение = СтрЗаменить(Выражение, "Collection(","");
				 Выражение = СтрЗаменить(Выражение, ")", "");
				 Выражение = СтрЗаменить(Выражение, "StandardODATA.","");
				 Выражение = СтрЗаменить(Выражение, "_Turnover", "");
				 Выражение = СтрЗаменить(Выражение, "_BalanceAndTurnover", "");
				 Выражение = СтрЗаменить(Выражение, "_Balance", "");
				 Выражение = СтрЗаменить(Выражение, "_ExtDimensions", "");
				 Выражение = СтрЗаменить(Выражение, "_RecordsWithExtDimensions", "");
				 Выражение = СтрЗаменить(Выражение, "_DrCrTurnover", "");
				 
				 
				 ТекстЗапроса = ПризнакОбращения+Выражение+"/"+ИмяФункции;
				 Если ВРег(ИмяФункции) = ВРег("Balance") Тогда
					 
					 ТекстЗапроса = ТекстЗапроса + "(Period=datetime'&КонецПериода')";					 
					 
				 ИначеЕсли ВРег(ИмяФункции) = ВРег("Turnovers") Тогда
					 
					 ТекстЗапроса = ТекстЗапроса + "(StartPeriod=datetime'&НачалоПериода',EndPeriod=datetime'&КонецПериода')";
					 
				 ИначеЕсли ВРег(ИмяФункции) = ВРег("BalanceAndTurnovers") Тогда
					 
					 ТекстЗапроса = ТекстЗапроса + "(StartPeriod=datetime'&НачалоПериода',EndPeriod=datetime'&КонецПериода')";
					 
				 Иначе	 
					 
					ТекстЗапроса = ТекстЗапроса + "()"; 
					 
				 КонецЕсли; 
				 
				 ИмяОбъектаПолное = Выражение;
				 Если Найти(ИмяОбъектаПолное, "RecordType") > 0 Тогда
					 
					 Продолжить;
					 
				 КонецЕсли; 
				 
				 ПозицияПодч = Найти(ИмяОбъектаПолное,"_");
				 ИмяКоллекции = Лев(ИмяОбъектаПолное, ПозицияПодч - 1);
				 ИмяОбъекта = Сред(ИмяОбъектаПолное, ПозицияПодч + 1);
				 
				 СтрОтбор = Новый Структура;
				 СтрОтбор.Вставить("Значение", ИмяОбъекта);
				 
				 Если ИмяКоллекции = "AccumulationRegister" Тогда
					 
					  НайденныеСтроки = СтрокаРН.Строки.НайтиСтроки(СтрОтбор);
					  
					  Если НайденныеСтроки.Количество() = 0 Тогда
						  
						  СтрокаОбъект = СтрокаРН.Строки.Добавить();
						  СтрокаОбъект.Значение = ИмяОбъекта;
						  СтрокаОбъект.Представление = ИмяОбъекта;
						  СтрокаОбъект.Уровень = 1;	
						  
					  Иначе	
						  
						  СтрокаОбъект = НайденныеСтроки[0];
						  
					  КонецЕсли; 
					 
				 ИначеЕсли ИмяКоллекции = "AccountingRegister" Тогда	
					 
					  НайденныеСтроки = СтрокаРБ.Строки.НайтиСтроки(СтрОтбор);
					  
					  Если НайденныеСтроки.Количество() = 0 Тогда
						  
						  СтрокаОбъект = СтрокаРБ.Строки.Добавить();
						  СтрокаОбъект.Значение = ИмяОбъекта;
						  СтрокаОбъект.Представление = ИмяОбъекта;
						  СтрокаОбъект.Уровень = 1;	
						  
					  Иначе	
						  
						  СтрокаОбъект = НайденныеСтроки[0];
						  
					  КонецЕсли; 
					  
					 
				 КонецЕсли; 
				 
				 Если НЕ СтрокаОбъект = Неопределено Тогда
					 
					 СтрокаДетали = СтрокаОбъект.Строки.Добавить();
					 СтрокаДетали.Значение = ТекстЗапроса;
					 СтрокаДетали.Представление =  ИмяФункции;
					 СтрокаДетали.Уровень = 2;				 
					 
				 КонецЕсли; 
				 
				 
			КонецЕсли; 
		
		КонецЦикла; 
		
		
	КонецЕсли; 
	
	РезСтруктура.Вставить("НомерТекущейСтроки", 0);
	РезСтруктура.Вставить("ХранилищеДереваВыбора", бит_ОбщегоНазначения.УпаковатьДеревоЗначений(ДеревоВыбора));
	РезСтруктура.Вставить("Режим", "HTTP");
	
	Возврат РезСтруктура;
	
КонецФункции // ПолучитьДоступныеЗапросыHTTP()

// Функция получает доступные поля HTTP запроса.
// 
// Параметры:
//   ЗапросСсылка - СправочникСсылка.бит_Запросы - объект обработки.
//   ТекущийТекстЗапроса - Строка.
// 
// Возвращаемое значение:
//  РезПоля - Структура.
// 
Функция ПолучитьДоступныеПоляHTTP(ЗапросСсылка, ТекущийТекстЗапроса) Экспорт
	
	РезПоля = Новый Структура;
	
	ПризнакОбращения = бит_мпд_КлиентСервер.ПризнакОбращенияОДата();
	
	// Поля, которые не добавляем
	Исключения = Новый Массив;
	Исключения.Добавить("LineNumber");
	Исключения.Добавить("Recorder");
	Исключения.Добавить("Recorder_Type");
	
	// Кэш для поиска типов
	Ассоциации = Новый Соответствие;
	
	
	ИмяТипа = СтрЗаменить(ТекущийТекстЗапроса, ПризнакОбращения, "");
	НомСлэш = Найти(ИмяТипа,"/");
	Если НомСлэш > 0 Тогда
		
		ИмяТипа = Лев(ИмяТипа, НомСлэш-1);
		
	КонецЕсли; 
	
	ИмяОбъекта = ИмяТипа;
	
	Если Найти(ТекущийТекстЗапроса, "Balance(") > 0 Тогда
		
		ИмяТипа = ИмяТипа+"_Balance";
		
	ИначеЕсли Найти(ТекущийТекстЗапроса, "Turnovers(") > 0 Тогда
		
		ИмяТипа = ИмяТипа+"_Turnover";
		
	ИначеЕсли Найти(ТекущийТекстЗапроса, "BalanceAndTurnovers(") > 0 Тогда	
		
		ИмяТипа = ИмяТипа+"_BalanceAndTurnover";
		
	КонецЕсли; 
	
	СтрОтвет = ПолучитьМетаданныеHTTP(ЗапросСсылка);
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(СтрОтвет);
	
	флОбходПолей = Ложь;
	ТекАссоциация = "";
	Пока Чтение.Прочитать() Цикл
		
		Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
			И Чтение.Имя = "ComplexType" 
			И Чтение.КоличествоАтрибутов() > 0 Тогда
			
			ТекИмя = Чтение.ПолучитьАтрибут("Name");
			
			Если ТекИмя = ИмяТипа Тогда
				
				 флОбходПолей = Истина;
				
			КонецЕсли; 
			
		КонецЕсли;
		
		// Поиск полей регистра
		Если флОбходПолей Тогда
			
			Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
				И Чтение.Имя = "Property" 
				И Чтение.КоличествоАтрибутов() > 0 Тогда
				
				ИмяПоля = Чтение.ПолучитьАтрибут("Name");
				ТипСтр = Чтение.ПолучитьАтрибут("Type");
				
				// Периоды не выводятся - ограничение платформы, невыводим.
				Если Найти(ИмяПоля,"Period") > 0 Тогда
					
					Продолжить;
					
				КонецЕсли; 
				
				Если НЕ Исключения.Найти(ИмяПоля) = Неопределено Тогда
				
					 Продолжить;
				
				КонецЕсли; 
				
				ОписаниеПоля = Новый Структура;
				ОписаниеПоля.Вставить("Имя", ИмяПоля);
				ОписаниеПоля.Вставить("ТипСтр", ТипСтр);
				ОписаниеПоля.Вставить("ТекстЗапроса", "");
				
				Если Найти(ИмяПоля,"_Key") > 0 Тогда
				
					ИмяБезКлюча = СтрЗаменить(ИмяПоля,"_Key","");
					ИмяАссоциации = ИмяОбъекта+"_RecordType_"+ИмяБезКлюча;
					Ассоциации.Вставить(ИмяАссоциации, ИмяПоля);
				
				КонецЕсли; 
				
				РезПоля.Вставить(ИмяПоля, ОписаниеПоля);
				
			КонецЕсли; 
			
			Если Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента И Чтение.Имя = "ComplexType" Тогда
				
				флОбходПолей = Ложь;
				
			КонецЕсли; 
			
		КонецЕсли; // Поиск полей регистра
		
		// Поиск типов в ассоциациях
		Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
			 И Чтение.Имя = "Association" Тогда
		
			ИмяАссоциации = Чтение.ПолучитьАтрибут("Name");
			
			Если НЕ Ассоциации[ИмяАссоциации] = Неопределено Тогда
			
				 ТекАссоциация = ИмяАссоциации;
			
			КонецЕсли; 
		
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(ТекАссоциация) Тогда
			
			Если Чтение.ТипУзла = ТипУзлаXML.НачалоЭлемента 
				И Чтение.Имя = "End" Тогда
				
				Роль = Чтение.ПолучитьАтрибут("Role");
				
				Если Роль = "End" Тогда
					
					ТипСтр = Чтение.ПолучитьАтрибут("Type");
					ТипСтр = СтрЗаменить(ТипСтр, "StandardODATA.", "");
					ИмяПоля = Ассоциации[ИмяАссоциации];
					Если ЗначениеЗаполнено(ИмяПоля) Тогда
						
						РезПоля[ИмяПоля].ТекстЗапроса = ТипСтр;
						
					КонецЕсли; 
					
				КонецЕсли; 
				
			КонецЕсли; 
			
			Если Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента И Чтение.Имя = "ComplexType" Тогда
				
				ИмяАссоциации = "";
				
			КонецЕсли; 
			
		КонецЕсли; // Поиск типов в ассоциациях
		
	КонецЦикла; // По узлам
	
	// Окончательная обработка выбранных полей
	Для каждого КиЗ Из РезПоля Цикл
	
		ОписаниеПоля = КиЗ.Значение;
		
		Если ЗначениеЗаполнено(ОписаниеПоля.ТекстЗапроса) Тогда
			
			Если Найти(ОписаниеПоля.ТекстЗапроса,"Catalog_") > 0 Тогда
				
				ОписаниеПоля.ТипСтр = СтрЗаменить(ОписаниеПоля.ТекстЗапроса, "Catalog_", "СправочникСсылка.");
				
			КонецЕсли; 
			
			Если Найти(ОписаниеПоля.ТекстЗапроса,"Document_") > 0 Тогда
				
				ОписаниеПоля.ТипСтр = СтрЗаменить(ОписаниеПоля.ТекстЗапроса, "Document_", "ДокументСсылка.");
				
			КонецЕсли; 
			
			ОписаниеПоля.ТекстЗапроса = ПризнакОбращения+ОписаниеПоля.ТекстЗапроса;
			
		Иначе	
			
			Если ВРег(ОписаниеПоля.ТипСтр) = ВРег("Edm.Double") Тогда
			
				ОписаниеПоля.ТипСтр = "Число";
				
			ИначеЕсли ВРег(ОписаниеПоля.ТипСтр) = ВРег("Edm.String") Тогда
				
				ОписаниеПоля.ТипСтр = "Строка";
				
			Иначе 	
				
				ОписаниеПоля.ТипСтр = "Строка";
				
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	Возврат РезПоля;
	
КонецФункции // ПолучитьДоступныеПоляHTTP()

#КонецОбласти
 
#КонецЕсли
