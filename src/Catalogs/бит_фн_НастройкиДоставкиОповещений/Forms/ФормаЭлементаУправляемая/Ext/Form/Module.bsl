
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
// 
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
    
	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	ЕстьСправочникВнешениеОбработки = ?(Метаданные.Справочники.Найти("ВнешниеОбработки") = Неопределено, Ложь, Истина);	
	
	// Получим доступные виды объектов и объекты системы.
	СписокВидовОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Обработка);
	
	// добавление кода. Начало: 05.12.2016 # BF-359 {{ 
	ЗаполнитьДоступныеОбъектыСистемы();
	
	// Заполнение нового элемента справочника
	Если НЕ ЗначениеЗаполнено(Объект.ОбработкаДоставки) Тогда
		
		Объект.ОбработкаДоставки = ДоступныеОбъектыСистемы[0].Значение;
		ЗаполнитьНастройкиДоставки();
		
	КонецЕсли;
	
	ЗаполнитьОписания();
	
	Если НЕ ИнициализацияВыполнена Тогда
	    УправлениеФормой(ЭтотОбъект); 
	КонецЕсли; 
	// добавление кода конец }}  
	
	ЭтаФорма.ОбработкаДоставкиПредыдущая = Объект.ОбработкаДоставки;
	
	Если ЗначениеЗаполнено(Объект.ОбработкаДоставки) Тогда
		
		ИмяОбработкиДоставки = Объект.ОбработкаДоставки.ИмяОбъекта;
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" формы.
// 
&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
	
		 Объект.НастройкиДоставки.Очистить();
		 Для каждого КиЗ Из ВыбранноеЗначение Цикл
		 
		 	 НоваяСтрока = Объект.НастройкиДоставки.Добавить();
			 НоваяСтрока.ИмяНастройки      = КиЗ.Ключ;
			 НоваяСтрока.ЗначениеНастройки = КиЗ.Значение;
		 
		 КонецЦикла; 
		 Модифицированность = Истина;
		 
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив();
	
	Если НЕ Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С Тогда
		МассивНепроверяемыхРеквизитов.Добавить("EMAILУчетнаяЗапись");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "НачалоВыбора" поля ввода "ОбработкаДоставки".
// 
&НаКлиенте
Процедура ОбработкаДоставкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбЗначение = Неопределено;
	Элемент.ВыбиратьТип = Ложь;			
	Если Объект.ОбработкаДоставки = Неопределено Тогда
	
		СписокВыбора = Новый СписокЗначений;
		СписокВыбора.Добавить("ВстроенныеОбработкиДоставки","Встроенные обработки доставки");
		Если ЕстьСправочникВнешениеОбработки Тогда
			
			СписокВыбора.Добавить("ВнешниеОбработкиДоставки"   ,"Внешние обработки доставки");
			
		КонецЕсли; 
		
		СтандартнаяОбработка = Ложь;
		
		ДопПараметры = Новый Структура("Элемент", Элемент);
		Оповещение = Новый ОписаниеОповещения("ВыборОбработкиДоставкиЗавершение", ЭтотОбъект, ДопПараметры);
		ПоказатьВыборИзСписка(Оповещение, СписокВыбора);
		
	Иначе	
		
		СтандартнаяОбработка = Ложь;		
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   ,Объект.ОбработкаДоставки);
		ПараметрыФормы.Вставить("ВидыОбъектов"           ,СписокВидовОбъектов);
		ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы",ДоступныеОбъектыСистемы);	
		ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая",ПараметрыФормы, Элемент);
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыборОбработкиДоставкиЗавершение".
// 
// Параметры:
// ВыбЗначение - ЭлементСпискаЗначений.
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура ВыборОбработкиДоставкиЗавершение(ВыбЗначение, ДополнительныеДанные) Экспорт

	Если ТипЗнч(Объект.ОбработкаДоставки) = Тип("СправочникСсылка.бит_ОбъектыСистемы") 
		  ИЛИ ( ВыбЗначение.Значение = "ВстроенныеОбработкиДоставки") Тогда
		
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   ,Объект.ОбработкаДоставки);
		ПараметрыФормы.Вставить("ВидыОбъектов"           ,СписокВидовОбъектов);
		ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы",ДоступныеОбъектыСистемы);	
		ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая",ПараметрыФормы, ДополнительныеДанные.Элемент);
		
		
	ИначеЕсли НЕ ВыбЗначение = Неопределено И ВыбЗначение.Значение = "ВнешниеОбработкиДоставки" Тогда
		
		Объект.ОбработкаДоставки = ПустаяВнешняяОбработка;
		
	КонецЕсли; 
	
КонецПроцедуры	// ВыборОбработкиДоставкиЗавершение

// Процедура - обработчик события "ПриИзменении" поля ввода "ОбработкаДоставки".
// 
&НаКлиенте
Процедура ОбработкаДоставкиПриИзменении(Элемент)
	
	Элементы.НастройкиДоставки.Видимость = Истина;
		
	 ЗаполнитьНастройкиДоставки();
	 ЭтаФорма.ОбработкаДоставкиПредыдущая = Объект.ОбработкаДоставки;
	 
	 ЗаполнитьОписания();
	 
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода "ОбработкаДоставки".
// 
&НаКлиенте
Процедура ОбработкаДоставкиОчистка(Элемент, СтандартнаяОбработка)
	
	Объект.ОбработкаДоставки = Неопределено;
	
КонецПроцедуры

// Процедура - обработчик события "Выбор" табличного поля "НастройкиДоставки".
// 
&НаКлиенте
Процедура НастройкиДоставкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтруктураНастроек = Новый Структура;
	
	Для каждого СтрокаТаблицы Из Объект.НастройкиДоставки Цикл
	
		СтруктураНастроек.Вставить(СтрокаТаблицы.ИмяНастройки,СтрокаТаблицы.ЗначениеНастройки);
	
	КонецЦикла; 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НастройкиДоставки",СтруктураНастроек);
	
	ОткрытьФорму("Обработка."+ИмяОбработкиДоставки+".Форма.ФормаНастройкиУправляемая",ПараметрыФормы,ЭтаФорма);
	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик команды "ОбновитьНастройки".
// 
&НаКлиенте
Процедура ОбновитьНастройки(Команда)
	
	ТекстВопроса =  НСтр("ru = 'Настройки доставки будут очищены и перезаполнены. Продолжить?'");
	
	Оповещение = Новый ОписаниеОповещения("ВопросОбОчисткеИПерезаполненииНастроекЗавершение", ЭтотОбъект);
	
	ПоказатьВопрос(Оповещение
					,ТекстВопроса
					,РежимДиалогаВопрос.ДаНет
					,30
					,КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// Процедура - обработчик оповещения "ВопросОбОчисткеИПерезаполненииНастроекЗавершение".
// 
&НаКлиенте
Процедура ВопросОбОчисткеИПерезаполненииНастроекЗавершение(Ответ, ДополнительныеДанные) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьНастройкиДоставки();
		
	КонецЕсли; 	

КонецПроцедуры // ВопросОбОчисткеИПерезаполненииНастроекЗавершение() 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура заполняет настройки доставки.
// 
&НаСервере
Процедура ЗаполнитьНастройкиДоставки()
	
	ОбъектОбработкаДоставки = бит_фн_ОповещенияСервер.ПолучитьОбработкуДоставки(Объект.ОбработкаДоставки);
	ИмяОбработкиДоставки = Объект.ОбработкаДоставки.ИмяОбъекта;
	
	Если НЕ ОбъектОбработкаДоставки = Неопределено Тогда
	
		// Проверим, что выбранная обработка является обработкой доставки.
		флОбработкаКорректна = бит_фн_ОповещенияСервер.ОбработкаДоставкиКорректна(ОбъектОбработкаДоставки
																					,Строка(Объект.ОбработкаДоставки)
																					,Истина);
		
		Если НЕ флОбработкаКорректна Тогда
			
			Объект.ОбработкаДоставки = ЭтаФорма.ОбработкаДоставкиПредыдущая;
			Возврат;
			
		КонецЕсли; 
		
		Объект.НастройкиДоставки.Очистить();			
		
		СтрНастройкиДоставки    = бит_фн_ОповещенияСервер.ПолучитьСтруктуруНастроекДоставки(ОбъектОбработкаДоставки);
		СтрНастройкиПоУмолчанию = ОбъектОбработкаДоставки.НастройкиПоУмолчанию();
		
		Для каждого КиЗ Из СтрНастройкиДоставки Цикл
			
			НоваяСтрока = Объект.НастройкиДоставки.Добавить();
			НоваяСтрока.ИмяНастройки      = КиЗ.Ключ;
			НоваяСтрока.ЗначениеНастройки = КиЗ.Значение;
			
			// Если значение настроки пусто - установим значение по-умолчанию.
			Если НЕ ЗначениеЗаполнено(КиЗ.Значение) Тогда
				
				Если СтрНастройкиПоУмолчанию.Свойство(КиЗ.Ключ) Тогда
					
					НоваяСтрока.ЗначениеНастройки = СтрНастройкиПоУмолчанию[КиЗ.Ключ];
					
				КонецЕсли; 
				
			КонецЕсли; 
			
		КонецЦикла; // По настройкам 
		
		Объект.СпособТранспорта = бит_фн_ОповещенияКлиентСервер.ОпределитьСпособТранспортаПоИмениОбработки(ИмяОбработкиДоставки);
		
	КонецЕсли; // Получили обработку доставки
	
	ИнициализацияВыполнена = Истина;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры // ЗаполнитьНастройкиДоставки()

// Управляет нгастройками элементов формы
// 
&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;

	ЭтоЭлектроннаяПочта1С = Объект.СпособТранспорта = ПредопределенноеЗначение("Перечисление.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С"); 
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-03-16 (#3669)
	//Элементы.EMAILУчетнаяЗапись.Видимость      = ЭтоЭлектроннаяПочта1С;
	//Заменено на:
	Элементы.EMAILУчетнаяЗапись.Видимость      = ЭтоЭлектроннаяПочта1С ИЛИ
												 Объект.СпособТранспорта = ПредопределенноеЗначение("Перечисление.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта");
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-03-16 (#3669)
	Элементы.ГруппаНастройкиДоставки.Видимость = НЕ ЭтоЭлектроннаяПочта1С;
	Элементы.ФормаОбновитьНастройки.Видимость  = НЕ ЭтоЭлектроннаяПочта1С;
	
КонецПроцедуры // УправлениеФормой()

// Выполняет заполнение реквизитов формы
// 
&НаСервере
Процедура ЗаполнитьОписания()
	
	Если Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-03-16 (#3669)
		 ИЛИ Объект.СпособТранспорта = ПредопределенноеЗначение("Перечисление.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта")
	 	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-03-16 (#3669)	
	Тогда
		СтрокиТаблицы = Объект.НастройкиДоставки.НайтиСтроки(Новый Структура("ИмяНастройки", "EMAILУчетнаяЗапись"));
		Если СтрокиТаблицы.Количество() = 0 Тогда
			EMAILУчетнаяЗапись = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
		Иначе
			EMAILУчетнаяЗапись = СтрокиТаблицы[0].ЗначениеНастройки;
		КонецЕсли; 
	КонецЕсли; 
	
	Если Объект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.PushNotification Тогда 

		Объект.НастройкиДоставки.Очистить();
		Элементы.НастройкиДоставки.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьОписания()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-03-16 (#3669)
	//Если ТекущийОбъект.СпособТранспорта = Перечисления.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С Тогда
	//Заменено на:
	Если ТекущийОбъект.СпособТранспорта = ПредопределенноеЗначение("Перечисление.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С") ИЛИ
	 	 ТекущийОбъект.СпособТранспорта = ПредопределенноеЗначение("Перечисление.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта") Тогда	
	//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-03-16 (#3669)
	
		СтрокиТаблицы = ТекущийОбъект.НастройкиДоставки.НайтиСтроки(Новый Структура("ИмяНастройки", "EMAILУчетнаяЗапись"));
		Если СтрокиТаблицы.Количество() = 0 Тогда
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-03-16 (#3669)
			Если ТекущийОбъект.СпособТранспорта = ПредопределенноеЗначение("Перечисление.бит_фн_СпособыТранспортаОповещений.ЭлектроннаяПочта1С") Тогда 
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-03-16 (#3669)
				СтрокаТаблицы = ТекущийОбъект.НастройкиДоставки.Добавить();
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-03-16 (#3669)
			Иначе 
				СтрокаТаблицы = ТекущийОбъект.НастройкиДоставки.Вставить(0);
			КонецЕсли;
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-03-16 (#3669)	
			СтрокаТаблицы.ИмяНастройки 		= "EMAILУчетнаяЗапись";
			СтрокаТаблицы.ЗначениеНастройки = EMAILУчетнаяЗапись;
		Иначе
			СтрокиТаблицы[0].ЗначениеНастройки = EMAILУчетнаяЗапись;
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

// Заполняет реквизит формы "ДоступныеОбъектыСистемы"
//
&НаСервере
Процедура ЗаполнитьДоступныеОбъектыСистемы()
		
	ОбъектыМД = Новый Массив();   
	ОбъектыМД.Добавить(Метаданные.Обработки.бит_фн_ОбработкаДоставкиОповещенийЭлектроннаяПочта1С);
	ОбъектыМД.Добавить(Метаданные.Обработки.бит_фн_ОбработкаДоставкиОповещенийПушУведомления);
	ОбъектыМД.Добавить(Метаданные.Обработки.бит_фн_ОбработкаДоставкиОповещенийTelegram);
	ОбъектыМД.Добавить(Метаданные.Обработки.бит_фн_ОбработкаДоставкиОповещенийЭлПочта);
	
	Для каждого ОбъектМД Из ОбъектыМД Цикл
		ОбъектСистемы = бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(ОбъектМД);
		Если НЕ ОбъектСистемы = Неопределено Тогда
			ДоступныеОбъектыСистемы.Добавить(ОбъектСистемы);
		КонецЕсли; 
	КонецЦикла; 

КонецПроцедуры // ЗаполнитьДоступныеОбъектыСистемы()

#КонецОбласти

