﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	УправлениеФормой(ЭтаФорма);
	
	// Уведомим о появлении нового функционала
	КлючиНастроек = "ОтправкаПоЭлектроннойПочте";
	НастройкиПредупреждений = ОбщегоНазначенияБП.НастройкиПредупрежденийОбИзменениях(КлючиНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
		
	ИБФайловая = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	ПодключитьОбработчикОжидания = Не ИБФайловая И ЗначениеЗаполнено(ИдентификаторЗадания);
	Если ПодключитьОбработчикОжидания Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	БухгалтерскиеОтчетыКлиент.ПриОткрытии(ЭтаФорма, Отказ);
	
	Если НастройкиПредупреждений.ОтправкаПоЭлектроннойПочте Тогда
		ПодключитьОбработчикОжидания("Подключаемый_ПоказатьИнформациюОтправкаПоЭлектроннойПочте", 0.5, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)

	БухгалтерскиеОтчетыКлиент.ПередЗакрытием(ЭтаФорма, Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОтменитьВыполнениеЗаданияНаСервере();
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииПользовательскихНастроекНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.ПриСохраненииПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Настройки)
	
	Если Не КомпоновщикИнициализирован Тогда
		ПользовательскиеНастройки = ПоместитьВоВременноеХранилище(Настройки, УникальныйИдентификатор);
	КонецЕсли;
	
	БухгалтерскиеОтчетыВызовСервера.ПриЗагрузкеПользовательскихНастроекНаСервере(ЭтаФорма, Настройки);
	
	Если Не КомпоновщикИнициализирован И ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	УправлениеФормой(ЭтаФорма);
	
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	БухгалтерскиеОтчетыВызовСервера.УстановитьНастройкиПоУмолчанию(ЭтаФорма);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ШАПКИ ФОРМЫ

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", Отчет.НачалоПериода, Отчет.КонецПериода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Отчет, РезультатВыбора, "НачалоПериода,КонецПериода");
	
	ОбновитьТекстЗаголовка(ЭтаФорма); 
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачалоПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонецПериодаПриИзменении(Элемент)
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияПриИзменении(Элемент)
	
	Если ОрганизацияИсходноеЗначение = ПолеОрганизация Тогда
		Возврат;
	КонецЕсли;
	
	ОрганизацияИзменилась = Истина;
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияПриИзменении(Элемент, ПолеОрганизация,
		Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
	Если КомпоновщикИнициализирован Тогда
		БухгалтерскиеОтчетыКлиент.ОрганизацияПриИзменении(ЭтаФорма, Элемент);
	КонецЕсли;
	
	ОбновитьИсходныеЗначения(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОткрытие(Элемент, СтандартнаяОбработка,
		ПолеОрганизация, СоответствиеОрганизаций);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияБПКлиент.ПолеОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка, 
		СоответствиеОрганизаций, Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПоЭлектроннойПочте(Команда)
	
	ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры
/////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ПОЛЯ РЕЗУЛЬТАТА

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПолучитьПараметрыРасшифровки(Расшифровка);	
			
	ЗаполняемыеНастройки = Новый Структура("Показатели, Группировка, Отбор, ВыводимыеДанные", Ложь, Истина, Ложь, Истина);
	ПараметрыФормы = Новый Структура("ВидРасшифровки, АдресНастроек, СформироватьПриОткрытии, ИДРасшифровки, ЗаполняемыеНастройки, МассивПолейРасшифровки",
			                                 1, ДанныеРасшифровки, Истина, "СБ_МежгрупповыеПоступленияИВыплаты", ЗаполняемыеНастройки, ПолучитьМассивПолейРасшифровки(Расшифровка));
	ОткрытьФорму("Отчет.СБ_МежгрупповыеПоступленияИВыплаты.Форма.Рашифровка", ПараметрыФормы,, Истина);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыРасшифровки(Расшифровка)
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровкиОбъекта = ДанныеОбъекта.ДанныеРасшифровки;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ДанныеРасшифровкиОбъекта.Настройки);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	
	МассивПолей = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеРасшифровкиОбъекта, КомпоновщикНастроек, Истина);
	ЕстьПоказатель = Ложь;
	
	Для Каждого Элемент Из МассивПолей Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			
			Если Элемент.Поле = "Показатель" Тогда
				ЕстьПоказатель = Истина;
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;
	
	Если ЕстьПоказатель Тогда
			УстановитьВсеПоказатели = Ложь;
		Иначе
			УстановитьВсеПоказатели = Истина;
		КонецЕсли;

	
	НастройкиРасшифровки = Новый Структура;   
	СписокПунктовМеню = Новый СписокЗначений;
	СписокПунктовМеню.Добавить("СБ_МежгрупповыеПоступленияИВыплаты");
	Если СписокПунктовМеню <> Неопределено Тогда
		Для Каждого ПунктМеню Из СписокПунктовМеню Цикл
			Если ТипЗнч(ПунктМеню.Значение) = Тип("Строка") Тогда
				НастройкиРасшифровки.Вставить(ПунктМеню.Значение, ПолучитьНастройкиДляРасшифровки(ПунктМеню.Значение, "СБ_МежгрупповыеПоступленияИВыплаты", МассивПолей, ОтчетОбъект, УстановитьВсеПоказатели));
			КонецЕсли;
		КонецЦикла;
		
		ДанныеОбъекта.Вставить("НастройкиРасшифровки", НастройкиРасшифровки);
		ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеОбъекта, ЭтаФорма.УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

&НаСервере
Функция ПолучитьНастройкиДляРасшифровки(ИДРасшифровки, ИдентификаторОбъекта, МассивПолей, ОтчетОбъект, УстановитьВсеПоказатели)
	
	ЕстьПоказатель  = Ложь;
	ЕстьКорЗначение = Ложь;
	ЕстьСчет        = Истина;
	ПервыйЭлемент   = Неопределено;
	Счет            = Неопределено;
	КорСчет         = Неопределено;
	Период          = Неопределено;
	БухТипРесурса   = Неопределено;
	Периодичность   = Неопределено;
	
	Для Каждого Элемент Из МассивПолей Цикл
		Если ТипЗнч(Элемент) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") Тогда
			Если ПервыйЭлемент = Неопределено И Элемент.Поле <> "Показатель" Тогда 
				ПервыйЭлемент = Элемент;
			КонецЕсли;
			Если Элемент.Поле = "Показатель" Тогда
				ЕстьПоказатель = Истина;
			КонецЕсли;
			Если Найти(Элемент.Поле, "Кор") = 1 Тогда
				ЕстьКорЗначение = Истина;
			КонецЕсли;
			Если Элемент.Поле = "КорСчет" Тогда
				КорСчет = Элемент.Значение;
			КонецЕсли;
			Если Элемент.Поле = "Счет" Тогда
				Счет = Элемент.Значение;
			КонецЕсли;
			Если Элемент.Поле = "Период" Тогда
				Период = Элемент.Значение;
			КонецЕсли;
			Если Элемент.Поле = "БухТипРесурса" Тогда
				БухТипРесурса = Элемент.Значение;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	ДобавитьОтборПоВидСубконто    = Истина;
	ДобавитьОтборПоВидКорСубконто = Истина;
	
	ПользовательскиеНастройкиОтчета = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	ПользовательскиеОтборы = ПользовательскиеНастройкиОтчета.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	ДополнительныеСвойства = ПользовательскиеНастройкиОтчета.ДополнительныеСвойства;
	
	// Передадим параметры заголовка и подвала
	ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", Ложь);
	ДополнительныеСвойства.Вставить("ВыводитьЕдиницуИзмерения", Ложь);
	ДополнительныеСвойства.Вставить("ВыводитьПодвал", Ложь);
	ЗаполнитьЗначенияСвойств(ДополнительныеСвойства, ОтчетОбъект);
	
	ПользовательскиеОтборы.ИдентификаторПользовательскойНастройки = "Отбор";

	
	ДополнительныеСвойства.Вставить("Счет", Счет);
	
	
	СписокПолейОтборов = Новый Массив;
		Для каждого Отбор из МассивПолей Цикл
			Если ТипЗнч(Отбор) = Тип("ЗначениеПоляРасшифровкиКомпоновкиДанных") тогда
				
				ЗначениеОтбора 	= Отбор.Значение;
				
				Если ЗначениеОтбора = NULL тогда
					Продолжить;
				КонецЕсли;

				ПолеОтбора 		= Отбор.Поле;
				Если Отбор.Поле = "БухТипРесурса" Тогда  // БухТипРесурса не обрабатываем и не переносим в расшифровывающий отчет
					
					Продолжить;
					
				ИначеЕсли Отбор.Поле = "Счет" И ЕстьСчет Тогда	// Счет задан в дополнительных свойствах, в отбор его добавлять не нужно
					
					Продолжить;
	 			ИначеЕсли (ПолеОтбора = "Счет" Или ПолеОтбора = "КорСчет") И Не ЕстьСчет Тогда
					Если ПолеОтбора = "КорСчет" И Не ПустаяСтрока(БухТипРесурса) Тогда      
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, "Счет" + ?(БухТипРесурса = "Дт", "Кт", "Дт"), ЗначениеОтбора, ВидСравненияКомпоновкиДанных.ВИерархии);	
					Иначе
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора, ВидСравненияКомпоновкиДанных.ВИерархии);		
					КонецЕсли;
				ИначеЕсли Найти(ПолеОтбора, "Субконто") = 1 Тогда
					
						ВидСравненияОтбора = Неопределено;
						ТипЗначенияОтбора = ТипЗнч(ЗначениеОтбора);
						// Если это строка то нужно поставить условие "Содержит"
						Если ТипЗначенияОтбора = Тип("Строка") Тогда  
						 	ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Содержит;
							
						// Если это группа справочника то нужно поставить условие "ВГруппе"
						ИначеЕсли ОбщегоНазначения.ЭтоСсылка(ТипЗначенияОтбора) И ОбъектЯвляетсяГруппой(ЗначениеОтбора) Тогда
							ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВИерархии;	
						КонецЕсли;
						// Устанавливаем отбор
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора, ВидСравненияОтбора);
					
					СписокПолейОтборов.Добавить(ПолеОтбора);				
				ИначеЕсли ПолеОтбора = "Подразделение" тогда
					
					Если ЗначениеЗаполнено(ЗначениеОтбора) Тогда
						ДополнительныеСвойства.Вставить("Подразделение", ЗначениеОтбора);
					КонецЕсли;
					
					Если Отбор.Иерархия Тогда
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора, ВидСравненияКомпоновкиДанных.ВИерархии);
					Иначе
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора);
					КонецЕсли;
					
				ИначеЕсли ПолеОтбора = "Организация" Тогда
					ДополнительныеСвойства.Вставить("Организация", ЗначениеОтбора);
				ИначеЕсли ПолеОтбора = "Показатель" Тогда 
					Показатель = ЗначениеОтбора;
				ИначеЕсли ПолеОтбора = "Период" Или ПолеОтбора = "Регистратор" Тогда 
				Иначе
					Если Отбор.Иерархия Тогда
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора, ВидСравненияКомпоновкиДанных.ВИерархии);
					Иначе
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора);
					КонецЕсли;
				КонецЕсли;	
			ИначеЕсли ТипЗнч(Отбор) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
				Если Отбор.Представление = "###ОтборПоОрганизацииСОП###" Тогда
					Для Каждого ЭлементОтбора Из Отбор.Элементы Цикл
						Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
							ДополнительныеСвойства.Вставить("Организация"                      , ЭлементОтбора.ПравоеЗначение);
							ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Истина);
						КонецЕсли;
					КонецЦикла;
				ИначеЕсли Отбор.Представление = "###Контроль###" Тогда
				КонецЕсли;
			ИначеЕсли ТипЗнч(Отбор) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
				
				ПолеОтбора 		= Отбор.ЛевоеЗначение;
				ЗначениеОтбора 	= Отбор.ПравоеЗначение;
				
				Если СписокПолейОтборов.Найти(Строка(Отбор.ЛевоеЗначение)) = Неопределено Тогда
					Если Отбор.Представление = "###ОтборПоОрганизации###" Тогда
						ДополнительныеСвойства.Вставить("Организация"                      , ЗначениеОтбора);
						ДополнительныеСвойства.Вставить("ВключатьОбособленныеПодразделения", Ложь);
					ИначеЕсли ПолеОтбора = Новый ПолеКомпоновкиДанных("Подразделение") 
						И Отбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
						ДополнительныеСвойства.Вставить("Подразделение", ЗначениеОтбора);
					КонецЕсли;
					
					// Транслируем отбор в расшифровочный отчет, только при определенных условиях
					Если Отбор.РежимОтображения <> РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный		// Это не недоступный отбор
						И Найти(Отбор.Представление, "###ОтборПоОрганизации###") = 0									// Это не отбор по организации
						И НЕ (Найти("АнализСубконто, ОборотыМеждуСубконто, КарточкаСубконто", ИдентификаторОбъекта) > 0	// Это не отбор по реквизитам счета или счету в Анализе, Карточке или оборотах между субконто
							И Найти(ПолеОтбора, "Счет") > 0)
					Тогда
						БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(ПользовательскиеОтборы, ПолеОтбора, ЗначениеОтбора, Отбор.ВидСравнения);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
			
	ДополнительныеСвойства.Вставить("Период", ОтчетОбъект.Период);
	ДополнительныеСвойства.Вставить("ПериметрКонсолидации", ОтчетОбъект.ПериметрКонсолидации);
	
			
	Возврат ПользовательскиеНастройкиОтчета;
	
КонецФункции

&НаСервере
Функция ОбъектЯвляетсяГруппой(Объект)
	
	Если Объект <> Неопределено Тогда 
		
		Результат = ОбщегоНазначения.ОбъектЯвляетсяГруппой(Объект);
		
		Если ТипЗнч(Результат) = Тип("Булево") Тогда
			
			Возврат Результат;	
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Возврат Ложь;
	
КонецФункции


&НаСервере
Функция ПолучитьМассивПолейРасшифровки(Расшифровка)
	//МассивПолейРасшифровки = бит_ОтчетыСервер.ПолучитьМассивПолейРасшифровки(Расшифровка, ПолучитьИзВременногоХранилища(ДанныеРасшифровки).ДанныеРасшифровки, Истина);
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);
	
	ОтчетОбъект       = ДанныеОбъекта.Объект;
	ДанныеРасшифровкиОбъекта = ДанныеОбъекта.ДанныеРасшифровки;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(КомпоновщикНастроек.ПолучитьНастройки());
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(ДанныеОбъекта.Объект.СхемаКомпоновкиДанных));
	МассивПолейРасшифровки = БухгалтерскиеОтчетыВызовСервера.ПолучитьМассивПолейРасшифровки(Расшифровка, ДанныеОбъекта.ДанныеРасшифровки, КомпоновщикНастроек, Истина);
	Возврат ПоместитьВоВременноеХранилище(МассивПолейРасшифровки, УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура РезультатОбработкаДополнительнойРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	// Не будем обрабатывать нажатие на правую кнопку мыши.
	// Покажем стандартное контекстное меню ячейки табличного документа.
	Расшифровка = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПриАктивизацииОбласти(Элемент)
	
	Если ТипЗнч(Результат.ВыделенныеОбласти) = Тип("ВыделенныеОбластиТабличногоДокумента") Тогда
		ИнтервалОжидания = ?(ПолучитьСкоростьКлиентскогоСоединения() = СкоростьКлиентскогоСоединения.Низкая, 1, 0.2);
		ПодключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый", ИнтервалОжидания, Истина);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ПОКАЗАТЕЛИ

&НаКлиенте
Процедура ПоказательПоступлениеПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказательРасходПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ГРУППИРОВКА

&НаКлиенте
Процедура ГруппировкаПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);  
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ГруппировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкаУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.Группировка Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОТБОРЫ

&НаКлиенте
Процедура ОтборыПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПриИзменении(ЭтаФорма, Элемент, Ложь);
	
	ОбновитьТекстЗаголовка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);

КонецПроцедуры

&НаКлиенте
Процедура ОтборыПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ОтборыПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборыПравоеЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СписокПараметров = ПолучитьПараметрыВыбораЗначенияОтбора();
	БухгалтерскиеОтчетыКлиент.ОтборыПравоеЗначениеНачалоВыбора(ЭтаФорма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ДОПОЛНИТЕЛЬНЫЕ ПОЛЯ

&НаКлиенте
Процедура РазмещениеДополнительныхПолейПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.ДополнительныеПоляПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляСнятьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Ложь;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеПоляУстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из Отчет.ДополнительныеПоля Цикл
		СтрокаТаблицы.Использование = Истина;
	КонецЦикла;
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ СОРТИРОВКА

&НаКлиенте
Процедура СортировкаПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломДобавления(ЭтаФорма, Элемент, Отказ, Копирование, Родитель, Группа);
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПередНачаломИзменения(Элемент, Отказ)
	
	БухгалтерскиеОтчетыКлиент.СортировкаПередНачаломИзменения(ЭтаФорма, Элемент, Отказ);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ГРУППЫ ОФОРМЛЕНИЕ

&НаКлиенте
Процедура МакетОформленияПриИзменении(Элемент)
	
	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметрВывода(Отчет.КомпоновщикНастроек.Настройки, "МакетОформления", МакетОформления);
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьЗаголовокПриИзменении(Элемент)

	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВыводитьПодвалПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеАктуальность");
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД ФОРМЫ

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
	Если РезультатВыполнения.Свойство("ОтказПроверкиЗаполнения") Тогда
		ПоказатьНастройки("");
	Иначе	
		ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНастройки(Команда)
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ЗакрытьНастройки", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьНастройки(Команда)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Подключаемый_ОткрытьНастройки", 0.1, Истина);
КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ОтменитьВыполнениеЗаданияНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьПараметрыОтчетаНаСервере()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("Период"		                    , Отчет.Период);
	ПараметрыОтчета.Вставить("ВидОтчета" 	                    , Отчет.ВидОтчета);
	ПараметрыОтчета.Вставить("ПериметрКонсолидации" 	        , Отчет.ПериметрКонсолидации);
	ПараметрыОтчета.Вставить("Группировка1"		                , Отчет.Группировка1);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , "izhtc_МакетОформленияОтчетовЧерноБелый");	
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , БухгалтерскиеОтчетыКлиентСервер.ПолучитьИдентификаторОбъекта(ЭтаФорма));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("ОстаткиПоОвердрафту"        		, Отчет.ОстаткиПоОвердрафту.Выгрузить());
	
		
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТекстЗаголовка(Форма)
	
	Отчет = Форма.Отчет;
	
	Название = ?(ЗначениеЗаполнено(Форма.ПредставлениеТекущегоВарианта), Форма.ПредставлениеТекущегоВарианта, "Межгрупповые поступления и выплаты");
	
	ЗаголовокОтчета = Название;
	
	Если ЗначениеЗаполнено(Отчет.Организация) И Форма.ИспользуетсяНесколькоОрганизаций Тогда
		ЗаголовокОтчета = ЗаголовокОтчета + " " + БухгалтерскиеОтчетыВызовСервера.ПолучитьТекстОрганизация(Отчет.Организация, Отчет.ВключатьОбособленныеПодразделения);
	КонецЕсли;
	
	Форма.Заголовок = ЗаголовокОтчета;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗапрещенныеПоля(Режим = "") Экспорт
	
	СписокПолей = Новый Массив;
	
	СписокПолей.Добавить("UserFields");
	СписокПолей.Добавить("DataParameters");
	СписокПолей.Добавить("SystemFields");
	СписокПолей.Добавить("Показатели");
	СписокПолей.Добавить("Период");
	
	Если Режим = "Выбор" Тогда
		СписокПолей.Добавить("ВидДвижения");
		СписокПолей.Добавить("ВидДенежныхСредств");
		СписокПолей.Добавить("Размещение");
	КонецЕсли;
	
	Если Режим = "Группировка" ИЛИ Режим = "Выбор" Тогда		
		БухгалтерскиеОтчетыКлиент.ДобавитьПоляРесурсовВЗапрещенныеПоля(ЭтаФорма, СписокПолей);
	КонецЕсли;
	
	Возврат Новый ФиксированныйМассив(СписокПолей);
	
КонецФункции

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", Ложь);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);

	ПараметрыОтчета = ПодготовитьПараметрыОтчетаНаСервере();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет", 
			ПараметрыОтчета, 
			БухгалтерскиеОтчетыКлиентСервер.ПолучитьНаименованиеЗаданияВыполненияОтчета(ЭтаФорма));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;		
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанныеНаСервере();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИсходныеЗначения(Форма)
	
	Форма.ОрганизацияИсходноеЗначение = Форма.ПолеОрганизация;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Отчет    = Форма.Отчет;
	Элементы = Форма.Элементы;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанныеНаСервере()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	Результат         = РезультатВыполнения.Результат;
	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанныеНаСервере();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере()
	
	ПолеСумма = БухгалтерскиеОтчетыВызовСервера.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		Результат, КэшВыделеннойОбласти);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РезультатПриАктивизацииОбластиПодключаемый()
	
	НеобходимоВычислятьНаСервере = Ложь;
	БухгалтерскиеОтчетыКлиент.ВычислитьСуммуВыделенныхЯчеекТабличногоДокумента(
		ПолеСумма, Результат, Элементы.Результат, КэшВыделеннойОбласти, НеобходимоВычислятьНаСервере);
	
	Если НеобходимоВычислятьНаСервере Тогда
		ВычислитьСуммуВыделенныхЯчеекТабличногоДокументаВКонтекстеНаСервере();
	КонецЕсли;
	
	ОтключитьОбработчикОжидания("Подключаемый_РезультатПриАктивизацииОбластиПодключаемый");
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьНастройки()
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.НастройкиОтчета;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЗакрытьНастройки()
	
	Элементы.РазделыОтчета.ТекущаяСтраница = Элементы.Отчет;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПараметрыВыбораЗначенияОтбора()
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Организация"       , Отчет.Организация);
	СписокПараметров.Вставить("Контрагент"        , Неопределено);
	СписокПараметров.Вставить("ДоговорКонтрагента", Неопределено);
	
	Возврат СписокПараметров;
	
КонецФункции

&НаСервере
//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-08-03 (#3816)
//Процедура ИнициализацияКомпоновщикаНастроек()
Процедура ИнициализацияКомпоновщикаНастроек() Экспорт
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-08-03 (#3816)
	
	БухгалтерскиеОтчетыВызовСервера.ИнициализацияКомпоновщикаНастроек(ЭтаФорма, ОрганизацияИзменилась);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтправки()
	
	ОтправкаПочтовыхСообщенийКлиент.ОтправитьОтчет(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПоказатьИнформациюОтправкаПоЭлектроннойПочте()
	
	//ОбщегоНазначенияБПКлиент.ПоказатьПредупреждениеОбИзменениях("ОтправкаПоЭлектроннойПочте", , НастройкиПредупреждений);
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоОвердрафту(Команда)
	
	Если Отчет.ВидОтчета <> 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("АдресОстаткиПоОвердрафту", ПолучитьАдресОстаткиПоОвердрафту());
	ПараметрыФормы.Вставить("Организация",				Отчет.Организация);
	
	ОткрытьФорму("Отчет.СБ_ПланИФактДДС.Форма.ФормаВводаОстатковПоОвердрафту", ПараметрыФормы, ЭтаФорма,,,, Новый ОписаниеОповещения("ОстаткиПоОвердрафтуЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиПоОвердрафтуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПодбор(Адрес) Экспорт
	ОбработатьПодборНаСервере(Адрес);
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодборНаСервере(Адрес)
	Отчет.ОстаткиПоОвердрафту.Загрузить(ПолучитьИзВременногоХранилища(Адрес));
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресОстаткиПоОвердрафту()
	
	Возврат ПоместитьВоВременноеХранилище(Отчет.ОстаткиПоОвердрафту.Выгрузить(), УникальныйИдентификатор);
	
КонецФункции

#КонецОбласти