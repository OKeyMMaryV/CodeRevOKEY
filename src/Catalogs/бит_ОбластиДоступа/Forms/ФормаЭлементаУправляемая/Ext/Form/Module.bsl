
#Область ОписаниеПеременных

&НаКлиенте
Перем мТекущийВидСравнения; // Служит для передачи вида сравнения между обработчиками.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();	
	// Вызов механизма защиты
	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если НЕ (Объект.Владелец.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Справочник 
			ИЛИ Объект.Владелец.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Документ) Тогда
			
			ТекстСообщения =  НСтр("ru = 'Область доступа может быть задана только для справочника или документа!'");
			бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
			Отказ = Истина;
			
		КонецЕсли; 
	КонецЕсли; 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;		
	
	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ВидСравненияРавно"  , ВидСравнения.Равно);
	
	ТабРеквизитов           = СформироватьТаблицуРеквизитов();
	ИменаКолонок = Новый Массив;
	Для каждого Колонка Из ТабРеквизитов.Колонки Цикл
	
		ИменаКолонок.Добавить(Колонка.Имя);
	
	КонецЦикла; 
	фАдресТаблицыРеквизитов = ПоместитьВоВременноеХранилище(ТабРеквизитов, УникальныйИдентификатор);
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		
		ТекущийОбъект = Параметры.ЗначениеКопирования.ПолучитьОбъект();
		
	Иначе	
		
		ТекущийОбъект = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект."+МетаданныеОбъекта.Имя));
		
	КонецЕсли; 
	СохраненнаяНастройка = ТекущийОбъект.ПолучитьНастройкиПостроителя();
	ВосстановитьОтбор(СохраненнаяНастройка);
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Сохранение отбора построителя
	СтруктураНастройки = Новый Структура;
	
	МассивОтбор = Новый Массив;
	Для каждого СтрокаОтбор Из ТаблицаОтбор  Цикл
	
		 ЭлементОтбора = бит_МеханизмПолученияДанных.ЭлементОтбора();
		 
		 ЗаполнитьЗначенияСвойств(ЭлементОтбора, СтрокаОтбор);
		 МассивОтбор.Добавить(ЭлементОтбора);
		 
	КонецЦикла; 
	
	СтруктураНастройки.Вставить("Отбор", МассивОтбор);	
	
	ТекущийОбъект.СохранитьНастройкиПостроителя(СтруктураНастройки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаОтбор

// Процедура - обработчик события "ПриНачалеРедактирования" табличного поля "ТаблицаОтбор".
// 
&НаКлиенте
Процедура ТаблицаОтборПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда
		
	  ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;		
		
	  Если Копирование Тогда
	  
		ТекущаяСтрока.ПутьКДанным = "";
		
	  Иначе
		  
		ТекущаяСтрока.Использование  = Истина;  
		ТекущаяСтрока.ВидСравнения   = фКэшЗначений.ВидСравненияРавно;
		
	  КонецЕсли; 	
	  
	  СтрПар = Новый Структура("АдресИсточникаПостроителя", фАдресТаблицыРеквизитов);
	  бит_мпд_Клиент.ОткрытьФормуПолейПостроителя(ТекущаяСтрока, "ТаблицаОтбор", "ПутьКДанным", "Отбор", "", СтрПар);
	
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "Выбор" табличного поля "ПолеНачалоВыбора".
// 
&НаКлиенте
Процедура ТаблицаОтборПолеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрПар = Новый Структура("АдресИсточникаПостроителя", фАдресТаблицыРеквизитов);
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;			  
	бит_мпд_Клиент.ОткрытьФормуПолейПостроителя(ТекущаяСтрока, "ТаблицаОтбор", "ПутьКДанным", "Отбор", "", СтрПар);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборВидСравненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	СписокВидов = СписокВыбораВидаСравнения(ТекущаяСтрока.ПолучитьИдентификатор());
	
	Элемент.СписокВыбора.Очистить();
	
	Для каждого Эл Из СписокВидов Цикл
	
		Элемент.СписокВыбора.Добавить(Эл.Значение, Эл.Представление);
	
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаОтборВидСравненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		
		ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
		мТекущийВидСравнения = ТекущаяСтрока.ВидСравнения;
		ТекущаяСтрока.ВидСравнения = ВыбранноеЗначение;
	    ИзменениеВидаСравнения(ТекущаяСтрока.ПолучитьИдентификатор(),мТекущийВидСравнения);		
	
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "ВидСравнения".
// 
&НаКлиенте
Процедура ТаблицаОтборВидСравненияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	ИзменениеВидаСравнения(ТекущаяСтрока.ПолучитьИдентификатор(),мТекущийВидСравнения);
	
КонецПроцедуры

&НаСервере
Процедура ИзменениеВидаСравнения(ИдСтроки,ПредВидСравнения)
	
	ТекущаяСтрока = ТаблицаОтбор.НайтиПоИдентификатору(ИдСтроки);
	
	бит_МеханизмПолученияДанных.ИзменениеВидаСравнения(ТекущаяСтрока, ПредВидСравнения);
		
КонецПроцедуры // ИзменениеВидаСравнения()

// Функция возвращает список доступных видов сравнения в зависимости от типа значения в строке.
// 
// Параметры:
//  ИдСтроки - Число.
// 
&НаСервере
Функция СписокВыбораВидаСравнения(ИдСтроки)
	
	ТекущаяСтрока = ТаблицаОтбор.НайтиПоИдентификатору(ИдСтроки);
	СписокВидов = бит_МеханизмПолученияДанных.СписокВыбораВидаСравнения(ТекущаяСтрока);
	
    Возврат СписокВидов;
	
КонецФункции // СписокВыбораВидаСравнения()

// Процедура - обработчик события "НачалоВыбора" поля ввода "Значение" табличного поля "ТаблицаОтбор".
// 
&НаКлиенте
Процедура ТаблицаОтборЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	бит_мпд_Клиент.ТаблицаОтборЗначениеНачалоВыбора(ЭтаФорма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события "Очистка" поля ввода "Значение" табличного поля "ТаблицаОтбор".
// 
&НаКлиенте
Процедура ТаблицаОтборЗначениеОчистка(Элемент, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТаблицаОтбор.ТекущиеДанные;
	
	бит_мпд_Клиент.ТаблицаОтборЗначениеОчистка(ТекущаяСтрока, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

// Процедура - обработчик события "ПриОкончанииРедактирования" табличного поля "ТаблицаОтбор".
// 
&НаКлиенте
Процедура ТаблицаОтборПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует таблицу реквизитов объекта системы. 
// Полученная таблица используется в качестве источника данных построителя.
// 
// Возвращаемое значение:
//  ТабРеквизитов - ТаблицаЗначений.
// 
&НаСервере
Функция СформироватьТаблицуРеквизитов()

	Если Объект.Владелец.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Справочник Тогда
		ТекОбъект= Справочники[Объект.Владелец.ИмяОбъекта].СоздатьЭлемент();
	ИначеЕсли Объект.Владелец.ВидОбъекта = Перечисления.бит_ВидыОбъектовСистемы.Документ Тогда	
		ТекОбъект= Документы[Объект.Владелец.ИмяОбъекта].СоздатьДокумент();
	КонецЕсли; 
	
	ТабРеквизитов = бит_ПраваДоступа.СформироватьТаблицуРеквизитовОбъекта(ТекОбъект,ТекОбъект.Метаданные());	

	Возврат ТабРеквизитов;
	
КонецФункции // СформироватьТаблицуРеквизитов()

//// Функция извлекает таблицу реквизитов из временного хранилища.
////
//// Возвращаемое значение:
////  ТабРеквизитов - ТаблицаЗначений.
////
// &НаСервере
// Функция ИзвлечьТаблицуРеквизитов()
// 	
// 	ТабРеквизитов = Неопределено;
// 	Если ЭтоАдресВременногоХранилища(фАдресТаблицыРеквизитов) Тогда
// 		
// 		ТабРеквизитов = ПолучитьИзВременногоХранилища(фАдресТаблицыРеквизитов);
// 		
// 	КонецЕсли; 
// 	
// 	Если НЕ ТипЗнч(ТабРеквизитов) = Тип("ТаблицаЗначений") Тогда
// 	
// 		 ТабРеквизитов = СформироватьТаблицуРеквизитов();
// 	
// 	КонецЕсли; 
// 	
// 	Возврат ТабРеквизитов;
// 	
// КонецФункции //  ИзвлечьТаблицуРеквизитов()

// Функция инициализирует построитель отчета по таблице реквизитов.
// 
// 
// Возвращаемое значение:
//  Построитель - ПостроительОтчета.
// 
&НаСервере
Функция ИнициализироватьПостроитель()
	
	Построитель   = Новый ПостроительОтчета;
	Если ЭтоАдресВременногоХранилища(фАдресТаблицыРеквизитов) Тогда
		
		ТабРеквизитов = ПолучитьИзВременногоХранилища(фАдресТаблицыРеквизитов);
		Попытка
			
			Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТабРеквизитов);
			
		Исключение
			
		КонецПопытки;
		
	КонецЕсли; 
	
	Возврат Построитель;
	
КонецФункции // ИнициализироватьПостроитель()

// Процедура восстанавливает отбор из хранилища значения.
// 
// Параметры:
//  СохраненнаяНастройка - Структура.
// 
&НаСервере
Процедура ВосстановитьОтбор(СохраненнаяНастройка)

	Если ТипЗнч(СохраненнаяНастройка)=Тип("Структура") Тогда
		
		Построитель = ИнициализироватьПостроитель();	
		
		Если СохраненнаяНастройка.Свойство("Отбор") Тогда
			
		    // Восстанавливаем отбор построителя			
			Для каждого ЭлементОтбора Из СохраненнаяНастройка.Отбор Цикл
				
				СтрокаОтбор = ТаблицаОтбор.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаОтбор, ЭлементОтбора);
				
				Если СтрокаОтбор.ПутьКДанным = "Периодичность" И ТипЗнч(СтрокаОтбор.Значение) = Тип("Число") Тогда
					
					СтрокаОтбор.ЭтоПериодичность = Истина;
					
				КонецЕсли; 
				
			КонецЦикла; 
			
		ИначеЕсли СохраненнаяНастройка.Свойство("НастройкиПостроителя") 
			И ТипЗнч(СохраненнаяНастройка.НастройкиПостроителя)=Тип("НастройкиПостроителяОтчета") Тогда
			
		   // Старый формат хранения настроек - для совместимости версий.
			Построитель.УстановитьНастройки(СохраненнаяНастройка.НастройкиПостроителя,Истина,Ложь,Истина,Истина);
			
			Для каждого ЭО Из Построитель.Отбор Цикл
				
				СтрокаОтбор = ТаблицаОтбор.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаОтбор, ЭО);
				
			КонецЦикла; 
			
		КонецЕсли; // Отбор	
		
	КонецЕсли;
	
КонецПроцедуры // ВосстановитьОтбор()

#КонецОбласти
