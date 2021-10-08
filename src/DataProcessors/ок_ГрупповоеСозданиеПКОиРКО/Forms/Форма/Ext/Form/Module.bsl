﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СчетУчета 	= ПредопределенноеЗначение("ПланСчетов.Хозрасчетный.КассаОрганизации");
		
	Дата = ТекущаяДата();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТипОперации = 0 Тогда
		ТипОперации = 1;
		ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход");
	КонецЕсли; 

	БухгалтерскийУчетКлиентСервер.УстановитьНачальныеСвойстваСубконтоШапки(
		ЭтотОбъект, ЭтотОбъект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УстановитьОграничениеТипов(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
		
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТаблицаДокументов.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьПользователю("Не заполнена табличная часть для формирования документов!", , Отказ);
	КонецЕсли;
	
	ПроверяемыеРеквизитыТаблицыДокументов	=	Новый Массив;
	ПроверяемыеРеквизитыТаблицыДокументов.Добавить("Объект");
	ПроверяемыеРеквизитыТаблицыДокументов.Добавить("Контрагент");
	ПроверяемыеРеквизитыТаблицыДокументов.Добавить("ДоговорКонтрагента");
	ПроверяемыеРеквизитыТаблицыДокументов.Добавить("СтатьяДДС");
	ПроверяемыеРеквизитыТаблицыДокументов.Добавить("КорСчет");
	ПроверяемыеРеквизитыТаблицыДокументов.Добавить("Сумма");
	
	МассивНепроверяемыхРеквизитовТаблицыДокументов	=	Новый Массив;
	
	Если ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход") Тогда
		МассивНепроверяемыхРеквизитовТаблицыДокументов.Добавить("Контрагент");
		МассивНепроверяемыхРеквизитовТаблицыДокументов.Добавить("ДоговорКонтрагента");
	ИначеЕсли ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ПрочийРасход") Тогда
		МассивНепроверяемыхРеквизитовТаблицыДокументов.Добавить("Контрагент");	
		МассивНепроверяемыхРеквизитовТаблицыДокументов.Добавить("ДоговорКонтрагента");	
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизитыТаблицыДокументов, МассивНепроверяемыхРеквизитовТаблицыДокументов);
		
	// Для колонки таблицы значений автоматическая проверка заполнения не выполняется.
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Для Каждого ПроверяемыйРеквизитТаблицыДокументов Из ПроверяемыеРеквизитыТаблицыДокументов Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы[ПроверяемыйРеквизитТаблицыДокументов]) Тогда
				ИдентификаторСтроки	=	СтрокаТаблицы.ПолучитьИдентификатор();
				
				ОбщегоНазначения.СообщитьПользователю("Не заполнена колонка """ + ПроверяемыйРеквизитТаблицыДокументов 
					+ """ в строке " + Формат(ИдентификаторСтроки + 1, "ЧГ=") + " списка ""Таблица документов""", ,
					"ТаблицаДокументов["+ ИдентификаторСтроки + "]." + ПроверяемыйРеквизитТаблицыДокументов, , Отказ);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Для реквизита составного типа автоматическая проверка заполнения не выполняется.
	Если Не ЗначениеЗаполнено(ВидОперации) Тогда
		ОбщегоНазначения.СообщитьПользователю("Поле """ + "Вид операции" + """ не заполнено.", , "ВидОперации", , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.Сумма) Тогда
			СтрокаТаблицы.Сумма	=	0;
		КонецЕсли;
		Если ЗначениеЗаполнено(СтрокаТаблицы.Документ) Тогда
			СтрокаТаблицы.Документ	=	Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, ЭтотОбъект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	УстановитьОграничениеТипов(ЭтаФорма);
	
	ВидОперации	=	Настройки.Получить("ВидОперации");	
	Субконто1	=	Настройки.Получить("Субконто1");
	Субконто2	=	Настройки.Получить("Субконто2");
	Субконто3	=	Настройки.Получить("Субконто3");
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура ТипОперацииПриИзменении(Элемент)
	
	УстановитьОграничениеТипов(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	ТаблицаДокументов.Очистить();
	
	Если ТипОперации = 1 И Не ТипЗнч(ВидОперации) = Тип("ПеречислениеСсылка.ВидыОперацийПКО") Тогда
		ВидОперации	=	ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход");
	ИначеЕсли ТипОперации = 2 И Не ТипЗнч(ВидОперации) = Тип("ПеречислениеСсылка.ВидыОперацийРКО") Тогда	
		ВидОперации	=	ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ПрочийРасход");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	
	ТаблицаДокументов.Очистить();
	УстановитьОграничениеТипов(ЭтаФорма);
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КорСчетПриИзменении(Элемент)
	
	ПриИзмененииКорСчета();
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто1ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто2ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(2);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Субконто3ПриИзменении(Элемент)
	
	ПриИзмененииСубконто(3);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовСубконто1ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоСтроки(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовСубконто2ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоСтроки(2);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовСубконто3ПриИзменении(Элемент)
	
	ПриИзмененииСубконтоСтроки(3);
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораСубконто(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеОбъекта = БухгалтерскийУчетКлиентСервер.ДанныеУстановкиПараметровСубконто(
		ЭтотОбъект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
	
	ОбщегоНазначенияБПКлиент.НачалоВыбораЗначенияСубконто(ЭтотОбъект, Элемент, СтандартнаяОбработка, ДанныеОбъекта);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовКорСчетПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
			
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект,
		ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконтоТаблицы(ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
	
	Если НоваяСтрока Тогда			
		ЗаполнитьСтрокуТаблицы(ТекущиеДанные, ЭтотОбъект);			
	КонецЕсли; 
	
	Если Копирование Тогда
		ТекущиеДанные.Документ	=	Неопределено;
	КонецЕсли;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСчета(
		ЭтотОбъект,
		ТекущиеДанные,
		ПараметрыУстановкиСвойствСубконтоТаблицы(ЭтотОбъект));

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДокументовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ТаблицаДокументовДокумент" Тогда
		
		СтандартнаяОбработка = Ложь;
	
		ТекущиеДанные = Элементы.ТаблицаДокументов.ТекущиеДанные;
		
		Если ТекущиеДанные.Документ = Неопределено Тогда
			Возврат;		
		КонецЕсли; 
		
		ОткрытьЗначение(ТекущиеДанные.Документ);
	
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура СтатьяДДСПриИзменении(Элемент)
	ОбновитьКолонкиТаблицыДокументов("СтатьяДДС");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Команда_Выполнить(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		Команда_ВыполнитьНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьКолонкиТаблицыДокументов(ИмяКолонки)
	
	Для Каждого СтрокаТаблицы Из ТаблицаДокументов Цикл
		ЗаполнитьЗначенияСвойств(СтрокаТаблицы, ЭтаФорма, ИмяКолонки);	
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура Команда_ВыполнитьНаСервере()
	
	Для Каждого СтрокаТЧ Из ТаблицаДокументов Цикл
				
		Если ЗначениеЗаполнено(СтрокаТЧ.Документ) Тогда
			Продолжить;
		КонецЕсли; 
		
		ПараметрыДокумента = Новый Структура("Организация, Дата, СчетКасса, ок_Объект, СуммаДокумента , ВидОперации, ТипОперации, 
											 |Контрагент, ДоговорКонтрагента, СтатьяДвиженияДенежныхСредств, СчетОрганизации, ПринятоОт, Выдать, 
											 |СпособПогашенияЗадолженности, СтавкаНДС, СчетУчетаРасчетовПоАвансам, Основание, Приложение, 
											 |СчетУчетаРасчетовСКонтрагентом, СубконтоДт1, СубконтоДт2, СубконтоДт3, СубконтоКт1, СубконтоКт2, СубконтоКт3");
		
		ПараметрыДокумента.Организация 							=	Организация;
		ПараметрыДокумента.Дата 								=	Дата;
		ПараметрыДокумента.ВидОперации 							=	ВидОперации;
		ПараметрыДокумента.ТипОперации 							=	ТипОперации;
		ПараметрыДокумента.СчетКасса 							=	СчетУчета;	
		ПараметрыДокумента.ок_Объект 							=	СтрокаТЧ.Объект;
		ПараметрыДокумента.СуммаДокумента 						=	СтрокаТЧ.Сумма;
		ПараметрыДокумента.Контрагент                         	=	СтрокаТЧ.Контрагент;
		ПараметрыДокумента.ДоговорКонтрагента                   =	СтрокаТЧ.ДоговорКонтрагента;
		ПараметрыДокумента.СтатьяДвиженияДенежныхСредств      	=	СтрокаТЧ.СтатьяДДС;
		ПараметрыДокумента.СчетУчетаРасчетовСКонтрагентом     	=	СтрокаТЧ.КорСчет;
		ПараметрыДокумента.СубконтоДт1                        	=	СтрокаТЧ.Субконто1;
		ПараметрыДокумента.СубконтоДт2                        	=	СтрокаТЧ.Субконто2;
		ПараметрыДокумента.СубконтоДт3                        	=	СтрокаТЧ.Субконто3;
		ПараметрыДокумента.СубконтоКт1                        	=	СтрокаТЧ.Субконто1;
		ПараметрыДокумента.СубконтоКт2                        	=	СтрокаТЧ.Субконто2;
		ПараметрыДокумента.СубконтоКт3                        	=	СтрокаТЧ.Субконто3;
		ПараметрыДокумента.СпособПогашенияЗадолженности         =	Перечисления.СпособыПогашенияЗадолженности.НеПогашать;
		ПараметрыДокумента.СтавкаНДС                            =	Перечисления.СтавкиНДС.БезНДС;
		ПараметрыДокумента.СчетУчетаРасчетовПоАвансам           =	СтрокаТЧ.КорСчет;
		
		ПараметрыДокумента.ПринятоОт                            =	СтрокаТЧ.ПринятоВыдано;
		ПараметрыДокумента.Выдать                               =	СтрокаТЧ.ПринятоВыдано;
		ПараметрыДокумента.Основание							=	СтрокаТЧ.Основание;
		ПараметрыДокумента.Приложение							=	СтрокаТЧ.Приложение;
		
		СтрокаТЧ.Документ = СоздатьДокумент(ПараметрыДокумента);	
		
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеФормой(Форма)
	
	//Контрагент
	Если 	Форма.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ОплатаПокупателя")
		Тогда
		Форма.Элементы.ТаблицаДокументовКонтрагент.Доступность 							=	Истина;
		Форма.Элементы.ТаблицаДокументовКонтрагент.АвтоОтметкаНезаполненного 			=	Истина;
		Форма.Элементы.ТаблицаДокументовКонтрагент.Видимость 							=	Истина;
		
		Форма.Элементы.ТаблицаДокументовДоговорКонтрагента.Доступность 					=	Истина;
		Форма.Элементы.ТаблицаДокументовДоговорКонтрагента.АвтоОтметкаНезаполненного 	=	Истина;
		Форма.Элементы.ТаблицаДокументовДоговорКонтрагента.Видимость 					=	Истина;
	Иначе
		Форма.Элементы.ТаблицаДокументовКонтрагент.Доступность 							=	Ложь;
		Форма.Элементы.ТаблицаДокументовКонтрагент.АвтоОтметкаНезаполненного 			=	Ложь;
		Форма.Элементы.ТаблицаДокументовКонтрагент.Видимость 							=	Ложь;
		
		Форма.Элементы.ТаблицаДокументовДоговорКонтрагента.Доступность 					=	Ложь;
		Форма.Элементы.ТаблицаДокументовДоговорКонтрагента.АвтоОтметкаНезаполненного 	=	Ложь;
		Форма.Элементы.ТаблицаДокументовДоговорКонтрагента.Видимость 					=	Ложь;
	КонецЕсли;
	
	//КорСчет
	Если 	Форма.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход") 
		Или Форма.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ПрочийРасход")
		Или Форма.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ОплатаПокупателя") Тогда
			Форма.Элементы.КорСчет.Доступность 									= Истина;
			Форма.Элементы.ТаблицаДокументовКорСчет.Доступность 				= Истина;
			Форма.Элементы.КорСчет.АвтоОтметкаНезаполненного 					= Истина;
			Форма.Элементы.ТаблицаДокументовКорСчет.АвтоОтметкаНезаполненного 	= Истина;
	Иначе
			Форма.Элементы.КорСчет.Доступность 									= Ложь;
			Форма.Элементы.ТаблицаДокументовКорСчет.Доступность 				= Ложь;
			Форма.Элементы.КорСчет.АвтоОтметкаНезаполненного 					= Ложь;
			Форма.Элементы.ТаблицаДокументовКорСчет.АвтоОтметкаНезаполненного 	= Ложь;
	КонецЕсли;
	
	//Субконто
	Если 	Форма.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход") 
		Или Форма.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ПрочийРасход")
		Тогда
		
		Форма.Элементы.Субконто1.Доступность 						= Истина;
		Форма.Элементы.Субконто2.Доступность 						= Истина;
		Форма.Элементы.Субконто3.Доступность 						= Истина;
		Форма.Элементы.ТаблицаДокументовСубконто1.Доступность 		= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто2.Доступность 		= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто3.Доступность 		= Ложь;
		
		Форма.Элементы.Субконто1.Видимость 							= Истина;
		Форма.Элементы.Субконто2.Видимость 							= Истина;
		Форма.Элементы.Субконто3.Видимость 							= Истина;
		Форма.Элементы.ТаблицаДокументовСубконто1.Видимость 		= Истина;
		Форма.Элементы.ТаблицаДокументовСубконто2.Видимость 		= Истина;
		Форма.Элементы.ТаблицаДокументовСубконто3.Видимость 		= Истина;
		
	Иначе
		
		Форма.Элементы.Субконто1.Доступность 						= Ложь;
		Форма.Элементы.Субконто2.Доступность 						= Ложь;
		Форма.Элементы.Субконто3.Доступность 						= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто1.Доступность 		= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто2.Доступность 		= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто3.Доступность 		= Ложь;
		
		Форма.Элементы.Субконто1.Видимость 							= Ложь;
		Форма.Элементы.Субконто2.Видимость 							= Ложь;
		Форма.Элементы.Субконто3.Видимость 							= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто1.Видимость 		= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто2.Видимость 		= Ложь;
		Форма.Элементы.ТаблицаДокументовСубконто3.Видимость 		= Ложь;
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОграничениеТипов(Форма)
	
	//Вид операции
	Если Форма.ТипОперации = 1 Тогда
		ОграничениеТипа 		= Новый ОписаниеТипов("ПеречислениеСсылка.ВидыОперацийПКО");
		ОграничениеТипаДокумент = Новый ОписаниеТипов("ДокументСсылка.ПриходныйКассовыйОрдер");		
		СписокВыбора = Новый Массив;
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход"));
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ОплатаПокупателя"));	
	Иначе
		ОграничениеТипа 		= Новый ОписаниеТипов("ПеречислениеСсылка.ВидыОперацийРКО");
		ОграничениеТипаДокумент = Новый ОписаниеТипов("ДокументСсылка.РасходныйКассовыйОрдер");
		СписокВыбора = Новый Массив;
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ПрочийРасход"));
	КонецЕсли; 
	
	Форма.Элементы.ВидОперации.ОграничениеТипа 				= ОграничениеТипа;
	Форма.Элементы.ВидОперации.СписокВыбора.ЗагрузитьЗначения(СписокВыбора);
	Форма.Элементы.ТаблицаДокументовДокумент.ОграничениеТипа 	= ОграничениеТипаДокумент;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСтрокуТаблицы(ТекущаяСтрока,  ДанныеЗаполнения)
	
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеЗаполнения, "СтатьяДДС");
	
	Если ДанныеЗаполнения.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ОплатаПокупателя") Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеЗаполнения, "КорСчет");
	ИначеЕсли ДанныеЗаполнения.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийПКО.ПрочийПриход") Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеЗаполнения, "КорСчет, Субконто1, Субконто2, Субконто3");		
	ИначеЕсли ДанныеЗаполнения.ВидОперации = ПредопределенноеЗначение("Перечисление.ВидыОперацийРКО.ПрочийРасход") Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, ДанныеЗаполнения, "КорСчет, Субконто1, Субконто2, Субконто3");
	КонецЕсли;
	
КонецПроцедуры
 
&НаСервереБезКонтекста 
Функция СоздатьДокумент(ПараметрыДокумента)
	
	ТипОперации = ПараметрыДокумента.ТипОперации;
	
	Если ТипОперации = 1 Тогда
		Документ = Документы.ПриходныйКассовыйОрдер.СоздатьДокумент();
	ИначеЕсли ТипОперации = 2 Тогда
		Документ = Документы.РасходныйКассовыйОрдер.СоздатьДокумент();
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
	
	ЗаполнитьЗначенияСвойств(Документ, ПараметрыДокумента);
	
	Документ.ВалютаДокумента 	=	Константы.ВалютаРегламентированногоУчета.Получить();
	Документ.Ответственный 		=	Пользователи.ТекущийПользователь();
		
	СтрокаРасшифровкиПлатежа	=	Документ.РасшифровкаПлатежа.Добавить();
	
	СтруктураКурса				=	РаботаСКурсамиВалют.ПолучитьКурсВалюты(Документ.ВалютаДокумента, Документ.Дата);
	
	ЗаполнитьЗначенияСвойств(СтрокаРасшифровкиПлатежа, ПараметрыДокумента);
	
	СтрокаРасшифровкиПлатежа.СуммаПлатежа 				=	ПараметрыДокумента.СуммаДокумента;
	СтрокаРасшифровкиПлатежа.СуммаВзаиморасчетов 		=	ПараметрыДокумента.СуммаДокумента;
	СтрокаРасшифровкиПлатежа.КурсВзаиморасчетов			=	СтруктураКурса.Курс;
	СтрокаРасшифровкиПлатежа.КратностьВзаиморасчетов	=	СтруктураКурса.Кратность;
	
	Попытка
		Документ.Записать(РежимЗаписиДокумента.Проведение);
		Возврат Документ.Ссылка;
	Исключение
	    ОбщегоНазначения.СообщитьПользователю(СтрШаблон("Не удалось провести документ по объекту %1, по причине %2", ПараметрыДокумента.ок_Объект, ОписаниеОшибки()));
		Возврат Неопределено;
	КонецПопытки; 
	
КонецФункции 

&НаКлиенте
Процедура ПриИзмененииКорСчета()
	
	Субконто1	=	Неопределено;
	Субконто2	=	Неопределено;
	Субконто3	=	Неопределено;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСчета(
		ЭтотОбъект, ЭтотОбъект, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
		
	ОбновитьКолонкиТаблицыДокументов("КорСчет");
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконто(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"Субконто", "", "Субконто", "", "КорСчет");
		
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Организация);
	
	Возврат Результат;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыУстановкиСвойствСубконтоТаблицы(Форма)

	Результат = БухгалтерскийУчетКлиентСервер.ПараметрыУстановкиСвойствСубконтоПоШаблону(
		"ТаблицаДокументовСубконто", "", "Субконто", "", "КорСчет");
	
	Результат.ДопРеквизиты.Вставить("Организация", Форма.Организация);
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура ПриИзмененииСубконто(НомерСубконто)
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоШапкиПриИзмененииСубконто(
		ЭтотОбъект, ЭтотОбъект, НомерСубконто, ПараметрыУстановкиСвойствСубконто(ЭтотОбъект));
		
	ОбновитьКолонкиТаблицыДокументов("Субконто"+НомерСубконто);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПриИзмененииСубконтоСтроки(НомерСубконто)
	
	СтрокаТаблицы = Элементы.ТаблицаДокументов.ТекущиеДанные;
	
	БухгалтерскийУчетКлиентСервер.УстановитьСвойстваСубконтоСтрокиПриИзмененииСубконто(
		ЭтотОбъект, 
		СтрокаТаблицы,
		НомерСубконто, 
		ПараметрыУстановкиСвойствСубконтоТаблицы(ЭтотОбъект));
		
КонецПроцедуры

#КонецОбласти
