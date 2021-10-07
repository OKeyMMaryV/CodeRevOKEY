﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
    
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
    
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, Объект);
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// Вызов механизма защиты
	бит_ОбщегоНазначения.ПроверитьДоступностьПроформ(Объект.Назначение, Отказ);	
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 	
		
	// Открытие нового 
   	Если Параметры.Ключ.Пустая() Тогда
		
		СформироватьСоответствиеСвязейПараметровВыбора();
		
		Генерировать = Ложь;
		Если Параметры.Свойство("ВидПроформы") Тогда
		
			Объект.ВидПроформы = Параметры.ВидПроформы;
			Объект.Назначение = Перечисления.бит_НазначенияПроформ.ПроизвольнаяФорма;
			Генерировать = Истина;
			
		КонецЕсли; 
		
		ПсевдоМетаданные = Справочники.бит_ВидыПроформ.ЭмулироватьМетаданные(Объект.ВидПроформы);
		ИмяПроформы      = Объект.ВидПроформы.Имя;
	
		// Инициализируем список фиксированных реквизитов.
		Документы.бит_Проформы.СписокФиксированныеРеквизиты(ФиксированныеРеквизиты);
	
		// При копировании
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования)
			ИЛИ Генерировать Тогда  	
			ИсточникКопирования = Параметры.ЗначениеКопирования;
			ГенерироватьФорму();                                              		
		КонецЕсли;
	
	КонецЕсли; 
	
	// Настройка формы в зависимости от назначения.
	ЭтоФСД = ?(Объект.Назначение = Перечисления.бит_НазначенияПроформ.ПроизвольнаяФорма, Ложь, Истина);
	
	Если ЭтоФСД Тогда
		
		Заголовок =  НСтр("ru = 'Форма сбора данных'");
		
		// Изменение кода. Начало. 28.02.2018{{
		Если НЕ ПолучитьФункциональнуюОпцию("бит_УХ") Тогда
			ВызватьИсключение НСтр("ru = 'Функционал доступен только в версии БИТ.ФИНАНС:Холдинг.'");
		КонецЕсли;	
		// Изменение кода. Конец. 28.02.2018}}
	Иначе	
		Заголовок =  НСтр("ru = 'Произвольная форма'");
	КонецЕсли; 
	
	Элементы.ФормаКомандаЗагрузить.Видимость = ЭтоФСД;
	
	Элементы.ОтразитьВЗакрытомПериоде.Видимость = бит_ПраваДоступа.ПолучитьЗначениеДопПраваПользователя(
	 					                           бит_ОбщиеПеременныеСервер.ЗначениеПеременной("ТекущийПользователь"),
	 					                           ПланыВидовХарактеристик.бит_ДополнительныеПраваПользователей.РазрешеноОтражениеДокументовВЗакрытомПериоде);
												   
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если бит_ОбщегоНазначенияКлиентСервер.ПроверитьИмяКласса(ВыбранноеЗначение, "РезультатПолученияДанныхПоИсточникам") Тогда
		
		Если ВыбранноеЗначение.Режим = "Заполнить" 
			И ЭтотОбъект[ВыбранноеЗначение.ИмяЗаполняемойТаблицы].Количество() > 0 Тогда 
			
			// В режиме заполнения существующие данные следует очистить.
            ДопПараметры = Новый Структура;
            ДопПараметры.Вставить("ВыбранноеЗначение", ВыбранноеЗначение);
			бит_РаботаСДиалогамиКлиент.ЗапросПодтвержденияОчисткиДанных(ЭтотОбъект, ДопПараметры);
			
		Иначе        
		
    		ЗаполнитьТабЧасть(ВыбранноеЗначение, ВыбранноеЗначение.ИмяЗаполняемойТаблицы, Ложь);
            
        КонецЕсли; // Режим заполнения
    
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПсевдоМетаданные = Справочники.бит_ВидыПроформ.ЭмулироватьМетаданные(Объект.ВидПроформы);
	ИмяПроформы      = Объект.ВидПроформы.Имя;
	
	// Инициализируем список фиксированных реквизитов.
	Документы.бит_Проформы.СписокФиксированныеРеквизиты(ФиксированныеРеквизиты);
	
	СформироватьСоответствиеСвязейПараметровВыбора();
	
	ГенерироватьФорму();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ Отказ Тогда
		
		СохранитьДанныеШапки(ТекущийОбъект);
		ТабДанные = ПодготовитьДанныеТабЧастей();
		ТекущийОбъект.СохранитьДанныеТабЧастей(ТабДанные);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
		
	Если ПараметрыЗаписи.РежимЗаписи = ПредопределенноеЗначение("РежимЗаписиДокумента.Проведение") Тогда
		КлючеваяОперация = "Проведениебит_Проформы";
		ОценкаПроизводительностиКлиент.ЗамерВремени(КлючеваяОперация,,Истина)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события "ПриИзменении" поля ввода "ВидПроформы".
// 
&НаКлиенте
Процедура ВидПроформыПриИзменении(Элемент)
	
	ВидПроформыИзменение();
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "ВидПроформы".
// 
&НаКлиенте
Процедура ВидПроформыНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
    ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("Назначение" , Объект.Назначение);
	ПараметрыФормы.Вставить("ТекЗначение", Объект.ВидПроформы);
	
	ОткрытьФорму("Справочник.бит_ВидыПроформ.ФормаВыбора", ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "ВалютаДокумента".
// 
&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
  ВалютаДокументаИзменение();	
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Организация".
// 
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияИзменение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область СтандартныеПодсистемыОбработчикиКоманд

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаКлиенте
Процедура КомандаОбновить(Команда)
	
	ГенерироватьФорму();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗагрузить(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидПроформы) Тогда
		
		ТекстСообщения = НСтр("ru = 'Поле ""Вид"" не заполнено'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
		
	КонецЕсли; 
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбора.МножественныйВыбор = Ложь;
	ДиалогВыбора.Фильтр = "Все файлы Excel (*.xls, *.xlsx)|*.xls; *.xlsx";
	
	ДиалогВыбора.Показать(Новый ОписаниеОповещения("КомандаЗагрузитьЗавершение", ЭтотОбъект)); 
	
КонецПроцедуры

// Обработка оповещения процедуры "КомандаЗагрузить".
//
// Параметры:
//  ВыбранныеФайлы			 - Массив - массив выбранных имен файлов или Неопределено, если выбор не осуществлен. 
//  ДополнительныеПараметры	 - Структура - значение, которое было указано при создании объекта ОписаниеОповещения.
//
&НаКлиенте
Процедура КомандаЗагрузитьЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		
		ТекстСостояние = НСтр("ru = 'Загрузка данных...'");
		Состояние(ТекстСостояние);
		
		// Открытие эксель
		ПолноеИмя = ВыбранныеФайлы[0];
		Отказ = Ложь;		
		
		Эксель = бит_ОбменДаннымиЭксельКлиентСервер.InitExcel(Ложь, Отказ);
		
		Если Отказ Тогда
			
			Возврат;
			
		КонецЕсли; 
		
		ЭксельКнига = бит_ОбменДаннымиЭксельКлиентСервер.OpenExcelFile(Эксель, ПолноеИмя, Отказ);
		
		Если Отказ Тогда
			
			Возврат;
			
		КонецЕсли;
		
		КомплектДанных = Новый Структура;
		КомплектДанных.Вставить("ИмяПроформы", ИмяПроформы);
		КомплектДанных.Вставить("ПсевдоМетаданные", ПсевдоМетаданные);
		КомплектДанных.Вставить("ВидПроформы", Объект.Ссылка);
		
		// Чтение источников выпадающих списков
		СпискиИсточники     = бит_ПроформыКлиентСервер.ПрочитатьСпискиИсточники(ЭксельКнига);
		КомплектДанных.Вставить("СпискиИсточники", СпискиИсточники);
		
		МодельДокумента = Новый Структура;
		
		// Чтение данных шапки
		ЛистШапка = Неопределено;
		Для каждого Лист Из ЭксельКнига.Sheets Цикл
			
			// Найдем лист с данными шапки требуемой проформы.
			ПараметрыЛиста = бит_ПроформыКлиентСервер.GetHiddenParams(Лист);
			
			Если ПараметрыЛиста.ВидЛиста = "Шапка" И ПараметрыЛиста.ИмяПроформы = ИмяПроформы Тогда
				
				ЛистШапка = Лист
				
			КонецЕсли; 
			
		КонецЦикла; 
		
		Если НЕ ЛистШапка = Неопределено Тогда
			
			бит_ПроформыКлиентСервер.ПрочитатьДанныеШапки(ЭксельКнига, ЛистШапка, ПсевдоМетаданные, ИмяПроформы, МодельДокумента);
			
		КонецЕсли; 
		
		// Чтение данных табличных частей
		бит_ПроформыКлиентСервер.ПрочитатьДанныеТабЧастей(ЭксельКнига, ПсевдоМетаданные, МодельДокумента, ИмяПроформы);
		
		КомплектДанных.Вставить("МодельДокумента", МодельДокумента);
		
		бит_ОбменДаннымиЭксельКлиентСервер.CloseExcelFile(ЭксельКнига, Ложь);
		бит_ОбменДаннымиЭксельКлиентСервер.QuitExcel(Эксель);		
		
		ТекстСостояние = НСтр("ru = 'Преобразование данных...'");
		Состояние(ТекстСостояние);
		
		// Преобразование данных 
		Модифицированность = Истина;
		ОбработатьЗагруженныеДанные(КомплектДанных);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузить(Команда)
	
	Если Модифицированность Тогда
		
		Оповещение = Новый ОписаниеОповещения("ВыгрузитьВопросЗавершение", ЭтотОбъект);
		ТекстСообщения = Нстр("ru = 'Для выполнение действия необходимо записать документ. Продолжить?'");
		ПоказатьВопрос(Оповещение,ТекстСообщения, РежимДиалогаВопрос.ДаНет, 15, КодВозвратаДиалога.Да);
		
	Иначе
		
		Состояние( НСтр("ru = 'Выгрузка в Excel'")+"..." );
		ДанныеДляВыгрузки = ПодготовитьДанныеДляВыгрузки();
		бит_ПроформыКлиентСервер.ВыгрузитьПроформы(ДанныеДляВыгрузки);
		
	КонецЕсли; 
	
КонецПроцедуры

// Процедура обработчик оповещения "ВыгрузитьВопросЗавершение".
// 
// Параметры:
// Ответ - КодВозвратаДиалога
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура ВыгрузитьВопросЗавершение(Ответ, ДополнительныеДанные) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		флВыгружать = Записать();
		
		Если флВыгружать Тогда
			
			Состояние( НСтр("ru = 'Выгрузка в Excel'")+"..." );
			ДанныеДляВыгрузки = ПодготовитьДанныеДляВыгрузки();
			бит_ПроформыКлиентСервер.ВыгрузитьПроформы(ДанныеДляВыгрузки);
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры	// ВыгрузитьВопросЗавершение

&НаКлиенте
Процедура КомандаЗаполнить(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Дата"                 , Объект.Дата);
	ПараметрыФормы.Вставить("Организация"          , Объект.Организация);
	ПараметрыФормы.Вставить("Сценарий"             , Объект.Сценарий);
	ПараметрыФормы.Вставить("ЦФО"                  , Объект.ЦФО);
	ПараметрыФормы.Вставить("ИмяЗаполняемойТаблицы", "Таблица_"+СтрЗаменить(Элементы.ГруппаСтраницы.ТекущаяСтраница.Имя, "Страница_", ""));
	
	ОткрытьФорму("Обработка.бит_ПолучениеДанныхПоИсточникам.Форма.Форма", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбщиеСлужебныеПроцедурыИФункции

&НаСервере
Функция ДобавитьПолеФормы(Имя, ПутьКДанным, НастройкиОтображения, ЭлементКонтейнер = Неопределено)

	ЭУ = Элементы.Добавить(Имя, Тип("ПолеФормы"), ЭлементКонтейнер);
	ЭУ.ПутьКДанным = ПутьКДанным;		
	
	Если НастройкиОтображения.ВидПоля = Перечисления.бит_ВидыПолейПроформы.ПолеФлажка Тогда
		
		ЭУ.Вид = ВидПоляФормы.ПолеФлажка;
		
	Иначе
		
		ЭУ.Вид                       = ВидПоляФормы.ПолеВвода;
		ЭУ.АвтоОтметкаНезаполненного = НастройкиОтображения.ПроверкаЗаполнения;
		ЭУ.Ширина                    = НастройкиОтображения.Ширина;
		ЭУ.КнопкаВыбора              = НастройкиОтображения.КнопкаВыбора;
		ЭУ.КнопкаОткрытия            = НастройкиОтображения.КнопкаОткрытия;
		ЭУ.КнопкаРегулирования       = НастройкиОтображения.КнопкаРегулирования;
		ЭУ.КнопкаОчистки             = НастройкиОтображения.КнопкаОчистки;
		
	КонецЕсли; 
	
	Возврат ЭУ;
	
КонецФункции // ДобавитьПолеФормы()

// Процедура устанавливает параметры выбора по владельцу для ДополнительныхЗначенийАналитики.
// 
// Параметры:
//  МетаРеквизит - Структура
//  НовоеПоле - ПолеФормы
// 
&НаСервере
Процедура УстановитьОтборПоАналитике(МетаРеквизит, НовоеПоле)
	
	Если МетаРеквизит.Тип.СодержитТип(Тип("СправочникСсылка.бит_ДополнительныеЗначенияАналитик")) Тогда
		
		Если ТипЗнч(МетаРеквизит.НастройкиОбмена.Настройки) = Тип("Структура") Тогда
			
			Для каждого эо  Из МетаРеквизит.НастройкиОбмена.Настройки.СтруктураНастроек.Отбор Цикл
				
				Если эо.Использование И эо.ВидСравнения = ВидСравнения.Равно И Найти(эо.ПутьКДанным, "Ссылка.Владелец") > 0 Тогда
					
					МассивПараметров = Новый Массив;
					НовыйПараметр = Новый ПараметрВыбора("Отбор.Владелец", эо.Значение);
					МассивПараметров.Добавить(НовыйПараметр);
					
					НовоеПоле.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
					
				КонецЕсли; 
				
			КонецЦикла; 
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры // УстановитьОтборПоАналитике()

// Процедура удаляет динамически созданные реквизиты и элементы формы.
// 
&НаСервере
Процедура УдалитьДинамическиеЭлементы()
	
	// Удаление "динамически созданных" реквизитов.
	МассивРеквизитов = ПолучитьРеквизиты();
	
	УдаляемыеРеквизиты = Новый Массив;
	Для каждого РеквФормы Из МассивРеквизитов Цикл
		
		Если Найти(РеквФормы.Имя,"Шапка_") > 0 ИЛИ Найти(РеквФормы.Имя,"Таблица_") > 0 Тогда
			
			УдаляемыеРеквизиты.Добавить(РеквФормы.Имя);
			
		КонецЕсли; 
		
	КонецЦикла; // МассивРеквизитов
	
	ИзменитьРеквизиты(,УдаляемыеРеквизиты);
	
	// Удаление "динамически созданных" элементов управления.	
	УдаляемыеЭлементы = Новый Массив;
	Для каждого ЭлФормы Из Элементы Цикл
		
		Если ТипЗнч(ЭлФормы) = Тип("ПолеФормы") И Найти(ЭлФормы.Имя,"Шапка_") > 0 Тогда
			
			// Удаляем динамические элементы шапки
			УдаляемыеЭлементы.Добавить(ЭлФормы);
			
		ИначеЕсли ТипЗнч(ЭлФормы) = Тип("ГруппаФормы") И Найти(ЭлФормы.Имя,"Страница_")>0 Тогда	
			
			// Достаточно удалить страницы на которых расположены таблицы.
			УдаляемыеЭлементы.Добавить(ЭлФормы);
			
		КонецЕсли; 
		
	КонецЦикла; // Элементы
	
	Для каждого ЭлФормы Из УдаляемыеЭлементы Цикл
		
		Элементы.Удалить(ЭлФормы);
		
	КонецЦикла; 
	
КонецПроцедуры // УдалитьДинамическиеЭлементы()

// Процедура добавляет реквизиты и элементы управления по настройке формы.
// 
&НаСервере
Процедура ДобавитьДинамическиеЭлементы()
	
	// Добавление реквизитов и элементов управления шапки.
	ДобавляемыеРеквизиты = Новый Массив;
	
	Для каждого МетаРеквизит Из ПсевдоМетаданные.Реквизиты Цикл
		
		Если бит_ПроформыКлиентСервер.ЭтоФиксированныйРеквизит(МетаРеквизит.Имя, ФиксированныеРеквизиты) Тогда
			
			// Настраиваем отображение фиксированных реквизитов.
			Элементы[МетаРеквизит.Имя].Видимость = Истина;
			Элементы[МетаРеквизит.Имя].АвтоотметкаНезаполненного = МетаРеквизит.НастройкиОтображения.ПроверкаЗаполнения;
			Продолжить;
		
		КонецЕсли; 
		
		ТекИмя = ИмяРеквизитаШапки(МетаРеквизит.Имя);
		НовыйРеквизит = Новый РеквизитФормы(ТекИмя, МетаРеквизит.Тип, , МетаРеквизит.Синоним, Истина);
		ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
		 
	КонецЦикла; 
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для каждого МетаРеквизит Из ПсевдоМетаданные.Реквизиты Цикл
		
		Если бит_ПроформыКлиентСервер.ЭтоФиксированныйРеквизит(МетаРеквизит.Имя, ФиксированныеРеквизиты) Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		ТекИмя = ИмяРеквизитаШапки(МетаРеквизит.Имя);
		НовоеПоле = ДобавитьПолеФормы(ТекИмя, ТекИмя, МетаРеквизит.НастройкиОтображения, Элементы.ГруппаСтраницаОсновные);
		
		// Отбор по владельцу доп. значений аналитик.
		УстановитьОтборПоАналитике(МетаРеквизит, НовоеПоле);
		
		УстановитьСвязиПараметровВыбора(МетаРеквизит, НовоеПоле);
		
	КонецЦикла; 
	
	// Добавление реквизитов и элементов управления табличных частей.
	ДобавляемыеРеквизиты = Новый Массив;	
	Для каждого КиЗ Из ПсевдоМетаданные.ТабличныеЧасти Цикл
		
		МетаТабЧасть = КиЗ.Значение;
		
		ИмяТаблицы = "Таблица_"+МетаТабЧасть.Имя;
		
		Описание = Новый ОписаниеТипов("ТаблицаЗначений");
		
		НоваяТаблица = Новый РеквизитФормы(ИмяТаблицы, Описание,  ,МетаТабЧасть.Синоним, Истина); 
		ДобавляемыеРеквизиты.Добавить(НоваяТаблица);
		
		Для каждого МетаРеквизит Из МетаТабЧасть.Реквизиты Цикл
			
			НовыйРеквизит = Новый РеквизитФормы(МетаРеквизит.Имя, МетаРеквизит.Тип, ИмяТаблицы, МетаРеквизит.Синоним);
			ДобавляемыеРеквизиты.Добавить(НовыйРеквизит);
			
		КонецЦикла; 
		
	КонецЦикла; 
	
	ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	Для каждого КиЗ Из ПсевдоМетаданные.ТабличныеЧасти Цикл
		
		МетаТабЧасть = КиЗ.Значение;
		
		ИмяСтраницы = "Страница_"+МетаТабЧасть.Имя;
		НоваяСтраница = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Элементы.ГруппаСтраницы);
		НоваяСтраница.Вид = ВидГруппыФормы.Страница;
		НоваяСтраница.Заголовок = МетаТабЧасть.Синоним;
		Элементы.Переместить(НоваяСтраница, Элементы.ГруппаСтраницы, Элементы.ГруппаПрочее);
		
		ИмяТаблицы = "Таблица_"+МетаТабЧасть.Имя;		
		НоваяТаблица = Элементы.Добавить(ИмяТаблицы, Тип("ТаблицаФормы"), НоваяСтраница);
		НоваяТаблица.ПутьКДанным = ИмяТаблицы;
		
		Для каждого МетаРеквизит Из МетаТабЧасть.Реквизиты Цикл
			
			ИмяЭлемента = ИмяТаблицы+"_"+МетаРеквизит.Имя;
			ПутьКДанным = ИмяТаблицы+"."+МетаРеквизит.Имя;
			НовоеПоле = ДобавитьПолеФормы(ИмяЭлемента, ПутьКДанным, МетаРеквизит.НастройкиОтображения, НоваяТаблица);
			
			// Отбор по владельцу доп. значений аналитик.
			УстановитьОтборПоАналитике(МетаРеквизит, НовоеПоле);
			
			УстановитьСвязиПараметровВыбора(МетаРеквизит, НовоеПоле, МетаТабЧасть.Имя);
			
		КонецЦикла; 
		
		// Кнопка заполнить в командную панель табличной части.
		ИмяЭлемента = ИмяТаблицы+"_ЗаполнитьПоИсточникам";
		КнЗаполнить = Элементы.Добавить(ИмяЭлемента, Тип("КнопкаФормы"), Элементы[ИмяТаблицы+"КоманднаяПанель"]);
		КнЗаполнить.ИмяКоманды = "КомандаЗаполнить";
		КнЗаполнить.Заголовок =  НСтр("ru = 'Заполнить'");
				
	КонецЦикла; 
	
	Если НЕ НоваяСтраница = Неопределено Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница = НоваяСтраница;
	Иначе	
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаОсновные;
	КонецЕсли; 

КонецПроцедуры // ДобавитьДинамическиеЭлементы()

// Процедура выполняет генерацию формы документа по настройке.
// 
&НаСервере
Процедура ГенерироватьФорму()
	
	Если НЕ ЗначениеЗаполнено(Объект.ВидПроформы) Тогда
		
		Возврат;
		
	КонецЕсли; 
	
	ПсевдоМетаданные = Справочники.бит_ВидыПроформ.ЭмулироватьМетаданные(Объект.ВидПроформы);
	ИмяПроформы      = Объект.ВидПроформы.Имя;		
	
	Для каждого ЭлСписка Из ФиксированныеРеквизиты Цикл
		
		Элементы[ЭлСписка.Значение].Видимость = Ложь;
	
	КонецЦикла; 
	
	УдалитьДинамическиеЭлементы();
	ДобавитьДинамическиеЭлементы();
	
	ВосстановитьДанныеШапки();
	ВосстановитьДанныеТабЧастей();	
	
КонецПроцедуры // ГенерироватьФорму() 

// Процедура обрабатывает изменение вида проформы.
// 
&НаСервере
Процедура ВидПроформыИзменение()

	Если Объект.Назначение <> Объект.ВидПроформы.Назначение Тогда
	
		Объект.ВидПроформы = Справочники.бит_ВидыПроформ.ПустаяСсылка();
	
	КонецЕсли; 
	
	ПсевдоМетаданные = Справочники.бит_ВидыПроформ.ЭмулироватьМетаданные(Объект.ВидПроформы);
	ИмяПроформы      = Объект.ВидПроформы.Имя;	
	ГенерироватьФорму();	

КонецПроцедуры

// Процедура обрабатывает изменение валюты документа.
// 
&НаСервере
Процедура ВалютаДокументаИзменение()

	СтрКурса = бит_КурсыВалют.ПолучитьКурсВалюты(Объект.ВалютаДокумента, Объект.Дата);
	Объект.КурсДокумента = СтрКурса.Курс;
	Объект.КратностьДокумента = СтрКурса.Кратность;

КонецПроцедуры // ВалютаДокументаИзменение()

// Процедура сохраняет в табличную часть данные шапки проформы. 
// 
// Параметры:
//  ТекущийОбъект - ДокументОбъект.бит_Проформы.
// 
&НаСервере
Процедура СохранитьДанныеШапки(ТекущийОбъект) 
	
	ТекущийОбъект.ДанныеШапки.Очистить();
	Для каждого МетаРеквизит Из ПсевдоМетаданные.Реквизиты Цикл
		
		Если бит_ПроформыКлиентСервер.ЭтоФиксированныйРеквизит(МетаРеквизит.Имя, ФиксированныеРеквизиты) Тогда
			
			ЗначениеРеквизита = ТекущийОбъект[МетаРеквизит.Имя];
			
		Иначе	
			
			ИмяРеквизита      = ИмяРеквизитаШапки(МетаРеквизит.Имя);
			ЗначениеРеквизита = ЭтотОбъект[ИмяРеквизита]; 
			
		КонецЕсли; 
		
		флЗаписывать = ЗначениеЗаполнено(ЗначениеРеквизита);
		
		Если флЗаписывать Тогда
			
			НоваяСтрока = ТекущийОбъект.ДанныеШапки.Добавить();
			НоваяСтрока.ИмяРеквизита = МетаРеквизит.Имя;
			НоваяСтрока.ЗначениеРеквизита = ЗначениеРеквизита;
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры // СохранитьДанныеШапки()

// Процедура восстанавливает данные шапки проформы из табличной части. 
// 
&НаСервере
Процедура ВосстановитьДанныеШапки()

	Для каждого СтрокаТаблицы Из Объект.ДанныеШапки Цикл
		
		Если бит_ПроформыКлиентСервер.ЭтоФиксированныйРеквизит(СтрокаТаблицы.ИмяРеквизита, ФиксированныеРеквизиты) Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		ИмяРеквизита = ИмяРеквизитаШапки(СтрокаТаблицы.ИмяРеквизита);
		ЭтотОбъект[ИмяРеквизита] = СтрокаТаблицы.ЗначениеРеквизита;
	
	КонецЦикла; 
	
КонецПроцедуры // ВосстановитьДанныеШапки() 

// Процедура сохраняет в табличную часть данные табличных частей проформы. 
// 
&НаСервере
Функция ПодготовитьДанныеТабЧастей()

	ТабДанные = Документы.бит_Проформы.КонструкторТаблицыХраненияТабЧасти();
	
	Для каждого КиЗ Из ПсевдоМетаданные.ТабличныеЧасти Цикл
		
		МетаТабЧасть = КиЗ.Значение;
		ИмяТаблицы   = "Таблица_"+МетаТабЧасть.Имя;
		
		Сч = 1;
		Для каждого СтрокаТаблицы Из ЭтотОбъект[ИмяТаблицы] Цикл
			ДобавленаСтрока = Ложь;
			Для каждого МетаРеквизит Из МетаТабЧасть.Реквизиты Цикл
				
				ЗначениеРеквизита = СтрокаТаблицы[МетаРеквизит.Имя];
				флЗаписывать	  = ЗначениеЗаполнено(ЗначениеРеквизита);
				
				Если флЗаписывать Тогда
					ДобавленаСтрока = Истина;
					НоваяСтрока = ТабДанные.Добавить();
					НоваяСтрока.ИмяТабличнойЧасти = МетаТабЧасть.Имя;
					НоваяСтрока.НомерСтрокиТаблицы = Сч;
					НоваяСтрока.ИмяРеквизита       = МетаРеквизит.Имя;
					НоваяСтрока.ЗначениеРеквизита  = ЗначениеРеквизита;
				КонецЕсли; 
			КонецЦикла; 
			Если ДобавленаСтрока Тогда
				Сч = Сч+1;
			КонецЕсли; 
		КонецЦикла; 
		
	КонецЦикла; 

	Возврат ТабДанные;
	
КонецФункции // СохранитьДанныеТабЧастей() 

// Процедура восстанавливает данные табличных частей проформы из табличной части ДанныеТабличныхЧастей.
// 
&НаСервере
Процедура ВосстановитьДанныеТабЧастей()
	
	Если ЗначениеЗаполнено(ИсточникКопирования) Тогда
		РезультатЗапроса = Документы.бит_Проформы.ПолучитьДанныеТабличныхЧастей(ИсточникКопирования);
	Иначе	
		РезультатЗапроса = Документы.бит_Проформы.ПолучитьДанныеТабличныхЧастей(Объект.Ссылка);
	КонецЕсли; 
	
	ВыборкаТаблица = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Для каждого КиЗ Из ПсевдоМетаданные.ТабличныеЧасти Цикл
	
		МетаТабЧасть = КиЗ.Значение;
		ИмяТаблицы	 = "Таблица_"+МетаТабЧасть.Имя;
		ТабФормы   	 = ЭтотОбъект[ИмяТаблицы];
		СтрОтбор 	 = Новый Структура("ИмяТабличнойЧасти", МетаТабЧасть.Имя);
		
		ВыборкаТаблица.Сбросить();
		Если ВыборкаТаблица.НайтиСледующий(СтрОтбор) Тогда
		
			ВыборкаСтроки = ВыборкаТаблица.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаСтроки.Следующий() Цикл
				СтрокаТаблицы = ТабФормы.Добавить();
				Детали		  = ВыборкаСтроки.Выбрать();
				Пока Детали.Следующий() Цикл
					СтрокаТаблицы[Детали.ИмяРеквизита] = Детали.ЗначениеРеквизита;
				КонецЦикла; 
			КонецЦикла; 
		КонецЕсли; 
	КонецЦикла; 
	
КонецПроцедуры // ВосстановитьДанныеТабЧастей() 

// Процедура распознает данные, загруженные из Эксель и записывает в текущий документ.
// 
// Параметры:
//  КомплектДанных - Структура.
// 
&НаСервере
Процедура ОбработатьЗагруженныеДанные(Знач КомплектДанных)
	
	СпискиИсточники  = КомплектДанных.СпискиИсточники;
	ПсевдоМетаданные = КомплектДанных.ПсевдоМетаданные;
	МодельДокумента  = КомплектДанных.МодельДокумента;
	
	Если МодельДокумента.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Нет данных для загрузки! Возможно выбран файл, не соответсвующий данному виду проформы.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	Документы.бит_Проформы.РаспознатьДанные(МодельДокумента, ПсевдоМетаданные, СпискиИсточники);
	
	// Заполнение стандартных реквизитов
	Для каждого МетаРеквизит Из ПсевдоМетаданные.СтандартныеРеквизиты Цикл
	
		ИмяРеквизита = МетаРеквизит.Имя;
		
		Если ИмяРеквизита = "Номер" Тогда
		
			Продолжить;
		
		КонецЕсли; 
		
		ЗагруженныйЭлемент = Неопределено;
		Если МодельДокумента.Свойство(ИмяРеквизита, ЗагруженныйЭлемент) Тогда
		
			Объект[ИмяРеквизита] = ЗагруженныйЭлемент.Значение;
		
		КонецЕсли; 
	
	КонецЦикла; 
	
	// Заполнение реквизитов объекта
	Для каждого МетаРеквизит Из ПсевдоМетаданные.Реквизиты Цикл
		
		ИмяРеквизита = МетаРеквизит.имя;
		ЗагруженныйЭлемент = Неопределено;
		Если МодельДокумента.Свойство(ИмяРеквизита, ЗагруженныйЭлемент) Тогда
			
			ЗначениеРеквизита = ЗагруженныйЭлемент.Значение;
			Если бит_ПроформыКлиентСервер.ЭтоФиксированныйРеквизит(ИмяРеквизита, ФиксированныеРеквизиты) Тогда
				Объект[ИмяРеквизита] = ЗначениеРеквизита;
			Иначе	
				ИмяРеквизитаФормы = ИмяРеквизитаШапки(ИмяРеквизита);
				ЭтотОбъект[ИмяРеквизитаФормы] = ЗначениеРеквизита;
			КонецЕсли; 
			
		КонецЕсли; 
		
	КонецЦикла; 
	
	// Обработка ситуации с незаполненной валютой и курсами.
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДокумента) Тогда
	
		 Объект.ВалютаДокумента = Константы.ВалютаРегламентированногоУчета.Получить();
		 Объект.КурсДокумента = 1;
		 Объект.КратностьДокумента = 1;
	
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Объект.КурсДокумента) ИЛИ НЕ ЗначениеЗаполнено(Объект.КратностьДокумента) Тогда
	
		ВалютаДокументаИзменение();
	
	КонецЕсли; 
	
	// Заполнение табличных частей
	Для каждого КиЗ Из ПсевдоМетаданные.ТабличныеЧасти Цикл
	
		МетаТабЧасть = КиЗ.Значение;
		ИмяТаблицы = ИмяТаблицыФормы(МетаТабЧасть.Имя);
		
		ЭтотОбъект[ИмяТаблицы].Очистить();
		
		Если МодельДокумента.Свойство(МетаТабЧасть.Имя) Тогда
		
			ТабДанные = МодельДокумента[МетаТабЧасть.Имя].ТаблицаДанных;
			Колонки = ТабДанные.Колонки;
			
			Для каждого СтрокаТаблицы Из ТабДанные Цикл
				
				// Проверка необходимости заполнения данной строки в проформу.
				флЕстьЗаполненные = Ложь;
				Для каждого Кол Из Колонки Цикл
				
					ТекЗначение = СтрокаТаблицы[Кол.Имя];
					Если ЗначениеЗаполнено(ТекЗначение) Тогда
					
						флЕстьЗаполненные = Истина;
						Прервать;
					
					КонецЕсли; 
				
				КонецЦикла; // Колонки
				
				Если флЕстьЗаполненные Тогда
					
					// Копирование данных строки в проформу
					НоваяСтрока = ЭтотОбъект[ИмяТаблицы].Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
					
				КонецЕсли; 
			
			КонецЦикла; // ТабДанные
		
		КонецЕсли; // МодельДокумента.Свойство(МетаТабЧасть.Имя).
	
	КонецЦикла; // ПсевдоМетаданные.ТабличныеЧасти
	
КонецПроцедуры // ОбработатьЗагруженныеДанные()

// Процедура обрабатывает изменение организации. 
// 
&НаСервере
Процедура ОрганизацияИзменение()
	
	// При изменении огранизации может измениться префикс
	// если префикс изменился очистим номер, чтобы при записи установился правильный префикс.
	Если Объект.Номер <> "" Тогда
		
		ПрофОбъект = РеквизитФормыВЗначение("Объект");
		
		Префикс  = ПрофОбъект.СформироватьПрефикс();
		ТекНомер = Объект.Номер;
		
		Если Объект.Назначение = Перечисления.бит_НазначенияПроформ.ПроизвольнаяФорма Тогда
		
			Префикс  = СтрЗаменить(Префикс, "ПФ-","");
			ТекНомер = СтрЗаменить(ТекНомер,"ПФ-","");
			
			Если Префикс = "" Тогда
			
				 Префикс = "0";
			
			КонецЕсли; 
			
		КонецЕсли; 
		
		ДлинаПрефикса = СтрДлина(Префикс);
		
		Если Лев(ТекНомер,ДлинаПрефикса) <> Префикс Тогда
			
			Объект.Номер = "";
			
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры // ОрганизацияИзменение()

&НаСервере
Процедура ЗаполнитьТабЧасть(ВыбранноеЗначение, ИмяЗаполняемойТаблицы, ОчищатьДанные)
	
	Модифицированность = Истина;
	
	Если ОчищатьДанные Тогда
	
		ЭтотОбъект[ИмяЗаполняемойТаблицы].Очистить();
	
	КонецЕсли; 
	
	ДанныеЗаполнения = бит_ОбщегоНазначения.РаспаковатьТаблицуЗначений(ВыбранноеЗначение.ХранилищеДанные);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ТаблицаЗначений") Тогда
		
		Для каждого СтрокаТаблицы Из ДанныеЗаполнения Цикл
			
			НоваяСтрока = ЭтотОбъект[ИмяЗаполняемойТаблицы].Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
			
		КонецЦикла; 
		
	КонецЕсли; 
	
	ТекстСообщения =  НСтр("ru = 'Заполнение завершено.'");
	бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
	
КонецПроцедуры // ЗаполнитьТабЧасть()

// Функция готовит данные для выгрузки в шаблон.
// 
// Возвращаемое значение:
//  ДанныеДляВыгрузки - Массив.
// 
&НаСервере
Функция ПодготовитьДанныеДляВыгрузки()

	МассивПроформ = Новый Массив;
	МассивПроформ.Добавить(Объект.Ссылка);
	ДанныеДляВыгрузки = Документы.бит_Проформы.ПодготовитьДанныеДляВыгрузки(МассивПроформ);

	Возврат ДанныеДляВыгрузки;
	
КонецФункции // ПодготовитьДанныеДляВыгрузки()

// Процедура формирует соответствие для определения связей параметров выбора реквизитов.
//
&НаСервере
Процедура СформироватьСоответствиеСвязейПараметровВыбора()

	СоответствиеСвязей = Новый Соответствие;
	
	// Для поля с типом Договор контрагента
	СтруктураСвязи = Новый Структура;
	СтруктураСвязи.Вставить(бит_ОбщегоНазначения.ОпределитьИмяРеквизитаКонтрагента(), Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	СтруктураСвязи.Вставить("Организация"	, Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СоответствиеСвязей.Вставить(Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов"), СтруктураСвязи);
	
	// Для поля с типом Банковский счет
	СтруктураСвязи = Новый Структура;
	СтруктураСвязи.Вставить("Владелец"			, Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СтруктураСвязи.Вставить("ВалютаДокумента"	, Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	СоответствиеСвязей.Вставить(Новый ОписаниеТипов("СправочникСсылка." + бит_ОбщегоНазначения.ПолучитьИмяСправочникаБанковскихСчетов()), СтруктураСвязи); 
	
	// Для поля с типом Подразделение
	СтруктураСвязи = Новый Структура;
	СтруктураСвязи.Вставить("Владелец", Новый ОписаниеТипов("СправочникСсылка.Организации"));
	СоответствиеСвязей.Вставить(Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций"), СтруктураСвязи);
	
	// Кэширование
	СоответствиеСвязейПараметровВыбора = Новый ФиксированноеСоответствие(СоответствиеСвязей);
	
КонецПроцедуры // СформироватьСоответствиеСвязейПараметровВыбора()

// Процедура устанавливает связи параметров выбора реквизитам
//  из заданного программно соответствия СформироватьСоответствиеСвязейПараметровВыбора(). 
//
&НаСервере
Процедура УстановитьСвязиПараметровВыбора(МетаРеквизит, НовоеПоле, ИмяТабличнойЧасти="")

	ПутьКРеквизитамШапки = ПсевдоМетаданные.Реквизиты;
	Если ИмяТабличнойЧасти="" Тогда
		ЭтоТабличнаяЧасть = Ложь;
	Иначе
		ЭтоТабличнаяЧасть = Истина;
		ПутьКРеквизитамТабЧасти = ПсевдоМетаданные.ТабличныеЧасти[ИмяТабличнойЧасти].Реквизиты;
	КонецЕсли; 
	
	СтруктураСвязи = СоответствиеСвязейПараметровВыбора.Получить(МетаРеквизит.Тип);
	Если СтруктураСвязи <> Неопределено Тогда
		
		НовыйМассив = Новый Массив();
		
		Для каждого Связь Из СтруктураСвязи Цикл
		
			Для каждого Рекв Из ПутьКРеквизитамШапки Цикл
			
				Если Связь.Значение = Рекв.Тип Тогда
					
					Если бит_ПроформыКлиентСервер.ЭтоФиксированныйРеквизит(Рекв.Имя, ФиксированныеРеквизиты) Тогда
						
						НоваяСвязь = Новый СвязьПараметраВыбора("Отбор."+Связь.Ключ, "Объект."+Рекв.Имя);
					Иначе	
						НоваяСвязь = Новый СвязьПараметраВыбора("Отбор."+Связь.Ключ, "Шапка_"+Рекв.Имя);
						
					КонецЕсли;
					НовыйМассив.Добавить(НоваяСвязь);
					Прервать;
				КонецЕсли; 
			КонецЦикла; 
			
			Если ЭтоТабличнаяЧасть Тогда
			
				Для каждого Рекв Из ПутьКРеквизитамТабЧасти Цикл
				
					Если Связь.Значение = Рекв.Тип Тогда
						
						НоваяСвязь = Новый СвязьПараметраВыбора("Отбор."+Связь.Ключ, "Элементы.Таблица_"+ИмяТабличнойЧасти+".ТекущиеДанные."+Рекв.Имя);
						НовыйМассив.Добавить(НоваяСвязь);
						Прервать;
					КонецЕсли; 
				КонецЦикла; 
			
			КонецЕсли; 
			
			Если Связь.Значение.Типы()[0] = Тип("СправочникСсылка.Валюты") Тогда
				
				НоваяСвязь = Новый СвязьПараметраВыбора("Отбор.ВалютаДенежныхСредств", "Объект.ВалютаДокумента");
				НовыйМассив.Добавить(НоваяСвязь);
			
			КонецЕсли; 
		КонецЦикла; 
		
		НовыеСвязи = Новый ФиксированныйМассив(НовыйМассив);
		Элементы[НовоеПоле.Имя].СвязиПараметровВыбора = НовыеСвязи;
		
	КонецЕсли; 

КонецПроцедуры // УстановитьСвязиПараметровВыбора()

// Оповещение на вопрос о подтверждение очистки.
//
// Параметры:
//  Результат    - КодВозвратаДиалога.
//  ДопПараметры - Структура.
//
&НаКлиенте
Процедура ОтветНаПотверждениеОчистки(РезультатОтвет, ДопПараметры) Экспорт
	
	ОчищатьДанные = РезультатОтвет = КодВозвратаДиалога.Да;
    
    Если ОчищатьДанные Тогда
        ВыбранноеЗначение = ДопПараметры.ВыбранноеЗначение;
        ЗаполнитьТабЧасть(ВыбранноеЗначение, ВыбранноеЗначение.ИмяЗаполняемойТаблицы, ОчищатьДанные);
    КонецЕсли;       
    
КонецПроцедуры // ОтветНаПотверждениеОчистки()

// Функция формирует имя реквизита шапки проформы.
// 
// Параметры:
//  вхИмя - Строка
// 
// Возвращаемое значение:
//  РезИмя - Строка.
// 
&НаКлиентеНаСервереБезКонтекста
Функция ИмяРеквизитаШапки(вхИмя)

	РезИмя = "Шапка_"+вхИмя;

	Возврат РезИмя;
	
КонецФункции

// Функция формирует имя таблицы проформы.
// 
// Параметры:
//  вхИмя - Строка
// 
// Возвращаемое значение:
//  РезИмя - Строка.
// 
&НаКлиентеНаСервереБезКонтекста
Функция ИмяТаблицыФормы(вхИмя)

	РезИмя = "Таблица_"+вхИмя;

	Возврат РезИмя;
	
КонецФункции

#КонецОбласти

#КонецОбласти

