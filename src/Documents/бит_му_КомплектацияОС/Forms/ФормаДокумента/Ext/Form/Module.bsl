////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция выполняет вызов серверной функции по синхронизации значения реквизита РучнаяКорректировка
// при корректировки движений через обработку "Результат проведения".
//
// Параметры:
//  фРучнаяКорректировка - Булево.
//
// Возвращаемое значение:
//  ДействиеВыполнено - Булево.
// 
&НаСервере
Функция ВыполнитьСинхронизациюРучнойКорректировки(фРучнаяКорректировка) Экспорт
	
	ДействиеВыполнено = бит_ОбщегоНазначения.ВыполнитьСинхронизациюРучнойКорректировки(Объект
																					  ,фРучнаяКорректировка);	
	Возврат ДействиеВыполнено;;
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// РАБОТА С КЭШЕМ РЕКВИЗИТОВ ФОРМЫ

// бит_MZyubin Процедура заполняет кэш реквизитов формы данными объекта
//
&НаСервере
Процедура ЗаполнитьТекущиеЗначенияРеквизитовФормы()
	
	Для каждого КлючИЗначение Из мКэшРеквизитовФормы Цикл
		
		мКэшРеквизитовФормы[КлючИЗначение.Ключ] = Объект[КлючИЗначение.Ключ];
		
	КонецЦикла; 
	
КонецПроцедуры //ЗаполнитьТекущиеЗначенияРеквизитовФормы()

// бит_MZyubin Процедура добавляет в кэш реквизитов текущее значение заданного реквизита
//
// Параметры 
// 	ИмяРеквизита       	 -	Строка                       	                                                                  
//
&НаСервере
Процедура ДобавитьВКэш(ИмяРеквизита)
	
	мКэшРеквизитовФормы[ИмяРеквизита] = Объект[ИмяРеквизита];	
	
КонецПроцедуры //ДобавитьВКэш()

// бит_MZyubin Процедура извлекает из кэша и присваивает объекту значение заданного реквизита
//
// Параметры 
// 	ИмяРеквизита       	 -	Строка                       	                                                                  
//
&НаСервере
Процедура ИзвлечьИзКэша(ИмяРеквизита)
	
	Объект[ИмяРеквизита] = мКэшРеквизитовФормы[ИмяРеквизита];
	
КонецПроцедуры

// бит_DKravchenko Процедура получает параметры основного средства.
//
// Параметры:
//  ТекущаяСтрока 		  – СтрокаТабличнойЧасти.ОсновныеСредства, массив ОС.
//  Отказ		  		  - Булево, по умолчанию Ложь.
//  НеИзменяемыеПараметры - Булево, по умолчанию Ложь.
//
&НаСервере
Процедура ПолучитьПараметрыОС(ТекущаяСтрока, Отказ = Ложь, НеИзменяемыеПараметры = Ложь)

	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ЭтоМассив = (ТипЗнч(ТекущаяСтрока) = Тип("Массив"));
	
	Если ЭтоМассив Тогда
		МассивОС = ТекущаяСтрока;
	Иначе
		МассивОС = ТекущаяСтрока.ОсновноеСредство;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(МассивОС) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Не НеИзменяемыеПараметры Тогда
		
		Отказ = Ложь;
				
		Если Отказ Тогда
			
			Если Не ЭтоМассив Тогда
				ТекущаяСтрока.ОсновноеСредство = ПредопределенноеЗначение("Справочник.ОсновныеСредства.ПустаяСсылка");
			КонецЕсли;
			
			Возврат;
		КонецЕсли;
		
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщить("Не выбрана организация - данные по основному средству не были заполнены.", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	
	// Заполним данные по основным средствам.
	ЗаполнитьДанныеПоОсновнымСредствам_Вызов_Функции(МассивОС, ?(ЭтоМассив, Неопределено, ТекущаяСтрока), НеИзменяемыеПараметры);
	
КонецПроцедуры // ПолучитьПараметрыОС()

// бит_DKravchenko Процедура выполняет заполнение в форме документа валюты МСФО.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура ЗаполнитьВалютуМСФО()
	
	// Получим валюту международного учета.
	мВалютаМеждУчета = бит_му_ОбщегоНазначения.ПолучитьВалютуМеждународногоУчета(Объект.Организация);
	СтрокаВалютаМежУчета = Строка(мВалютаМеждУчета);
	
	Элементы.ВалютаМСФО.Заголовок = ?(ПустаяСтрока(СтрокаВалютаМежУчета), "НЕ УСТАНОВЛЕНА", СтрокаВалютаМежУчета);
	
КонецПроцедуры // ЗаполнитьВалютуМСФО()

// бит_DKravchenko Процедура обрабатывает изменение счета незавершенного строительства
// В строке табличного поля "ОсновныеСредства".
&НаСервере
Процедура ПриИзмененииСчетаНезавершенногоСтроительства(ИдСтроки)
	Сообщить("Закомментареный код!");
	//ТекущаяСтрока = Объект.ОсновныеСредства.НайтиПоИдентификатору(ИдСтроки);
	
	//бит_РаботаСДиалогами.ПриВыбореСчетаВТабличномПоле(ТекущаяСтрока.СчетНезавершенногоСтроительства
	//												 ,Элементы.ОсновныеСредства.ПодчиненныеЭлементы
	//												 ,ТекущаяСтрока
	//												 ,"Субконто"
	//												 ,"Субконто"
	//												 ,мКоличествоСубконтоМУ);

	
	// Синхронизируем реквизиты строки ОС.
	//СинхронизироватьРеквизитыСтрокиОС_Вызов_Функции(ТекущаяСтрока, "Субконто");
													 
	//бит_РаботаСДиалогами.ВывестиИменаСубконтоВШапке(Элементы.ОсновныеСредства.ПодчиненныеЭлементы
	//											   ,ТекущаяСтрока
	//											   ,"Субконто"
	//											   ,"Субконто"
	//											   ,мКоличествоСубконтоМУ);
													 
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	// вызов механизма защиты
	бит_ЛицензированиеБФCервер.ПроверитьВозможностьРаботы(ЭтаФорма,МетаданныеОбъекта.ПолноеИмя(),Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	_объект = РеквизитФормыВЗначение("Объект");
	// вызов механизма разделения прав доступа
	бит_ПраваДоступа.ПередОткрытиемФормы(Отказ,СтандартнаяОбработка,_объект,ЭтаФорма);

	ИжТиСи_СВД_Сервер.ОК_ВывестиРеквизиты(ЭтаФорма, "Документ.бит_му_КомплектацияОС.ФормаДокумента");

	Если Объект.Ссылка.Пустая() Тогда
		бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(_объект, ПользователиКлиентСервер.ТекущийПользователь(), Параметры.ЗначениеКопирования);
		ЗначениеВРеквизитФормы(_объект, "Объект");
	КонецЕсли;
			
	// запомним текущие значения реквизитов формы
	ЗаполнитьТекущиеЗначенияРеквизитовФормы();
	
	// Заполнить соответствие объектов ОС и их инвентарных номеров
	//бит_му_ВНА.ЗаполнитьСоответствиеОС_ИнвентарныйНомер(СоответствиеОС_ИнвентарныйНомер
	//												   ,Объект.ОсновныеСредства.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство")
	//												   ,Объект.Организация);
	
	// Заполним валюту МСФО.
	ЗаполнитьВалютуМСФО();
	
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ГруппаПечать);
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтаФорма);
	
	мКоличествоСубконтоМУ = 4;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновлениеОтображения();
КонецПроцедуры

// Процедура - обработчик события ""Нажатие"" кнопки ""ОткрытьСИ"" коммандной панели ""ДействияФормы"". 
// Открывает справку по данной форме.
//
&НаКлиенте
Процедура бит_си_ДействияФормыОткрытьСИ(Команда)
	Форма = ПолучитьФорму("Обработка.бит_си_СправочнаяИнформация.Форма.ФормаУправляемая", Новый Структура("ПараметрОткрытия", "Документ.бит_му_КомплектацияОС.ФормаДокумента"), ЭтаФорма);
	Форма.Открыть();
КонецПроцедуры

// Процедура - обработчик события "Нажатие" кнопки "ДИ:ПрикрепленныеФайлы" коммандной панели "ДействияФормы". 
// Открывает обработку "Прикрепленные файлы".
//
&НаКлиенте
Процедура бит_ДействияФормыПрикрепленныеФайлы(Команда)
	//бит_РаботаСДиалогами.ОткрытьОбработкуПрикрепленияФайлов(Ложь, ТекущиеДанные.Ссылка, ЭтаФорма);
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Предупреждение("Для выполнения данной операции необходимо записать документ.", 30);
		Возврат;
	КонецЕсли;
	
	Форма = ПолучитьФорму("Обработка.бит_ПрикреплениеФайлов.Форма.ФормаУправляемая", Новый Структура("ПараметрОткрытия", "Документ.бит_му_КомплектацияОС.ФормаДокумента"), ЭтаФорма, Объект.Ссылка);
	Форма.Объект.Объект = Объект.Ссылка;
	Форма.Открыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


// бит_DKravchenko Процедура - обработчик события "ОбновлениеОтображения" формы.
//
&НаКлиенте
Процедура ОбновлениеОтображения()
	// Подсчитаем количество строк в табличных частях.
	Элементы.ОсновныеСредства1.Заголовок = "Основные средства (" + Объект.ОсновныеСредства.Количество() + " поз.)";
КонецПроцедуры

&НаСервере
Функция ОбработкаВыбора_Сервер(МассивДокументовБУ, ЗаменятьИдентичные)
	ТаблицаДвиженийДокументовРСБУ      = ПолучитьДвиженияПоХозрасчетномуРегистру_Вызов_Функции(МассивДокументовБУ);
	
	Для Каждого Документ Из МассивДокументовБУ Цикл
		
		ЗапросДвиженийДокумента = Новый Запрос;
		ЗапросДвиженийДокумента.Текст = "ВЫБРАТЬ
		|	ТаблицаДвиженийДокументов.СчетДт,
		|	ТаблицаДвиженийДокументов.СчетКт,
		|	ТаблицаДвиженийДокументов.СубконтоДт1,
		|	ТаблицаДвиженийДокументов.СубконтоДт2,
		|	ТаблицаДвиженийДокументов.СубконтоДт3,
		|	ТаблицаДвиженийДокументов.СубконтоКт1,
		|	ТаблицаДвиженийДокументов.СубконтоКт2,
		|	ТаблицаДвиженийДокументов.СубконтоКт3,
		|	ТаблицаДвиженийДокументов.СуммаОборот,
		|	ТаблицаДвиженийДокументов.НомерСтрокиДвижений,
		|	ТаблицаДвиженийДокументов.ДокументРСБУ
		|ПОМЕСТИТЬ ВТДвижения
		|ИЗ
		|	&ТаблицаДвиженийДокументов КАК ТаблицаДвиженийДокументов
		|ГДЕ
		|	ТаблицаДвиженийДокументов.ДокументРСБУ = &Регистратор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТДвижения.СчетДт КАК СчетДтРСБУ,
		|	ВТДвижения.СчетКт КАК СчетКтРСБУ,
		|	ВТДвижения.СубконтоДт1,
		|	ВТДвижения.СубконтоДт2,
		|	ВТДвижения.СубконтоДт3,
		|	ВТДвижения.СубконтоКт1,
		|	ВТДвижения.СубконтоКт2,
		|	ВТДвижения.СубконтоКт3,
		|	ВТДвижения.НомерСтрокиДвижений,
		|	ВТДвижения.СуммаОборот КАК Сумма,
		|	ВТДвижения.ДокументРСБУ
		|ИЗ
		|	ВТДвижения КАК ВТДвижения";
		ЗапросДвиженийДокумента.УстановитьПараметр("ТаблицаДвиженийДокументов", ТаблицаДвиженийДокументовРСБУ);												
		ЗапросДвиженийДокумента.УстановитьПараметр("Регистратор", Документ);
		
		ТаблицаДвиженийДокумента = ЗапросДвиженийДокумента.Выполнить().Выгрузить();
		
		Если ЗаменятьИдентичные Тогда
			ИмеющиесяСтроки = Объект.ОсновныеСредства.НайтиСтроки(Новый Структура("ДокументРСБУ", Документ));
			Для Каждого НайденнаяСтрока Из ИмеющиесяСтроки Цикл
				Объект.ОсновныеСредства.Удалить(НайденнаяСтрока);
			КонецЦикла;
		//Иначе
		//	Продолжить;
		КонецЕсли;
		
		Для каждого СтрокаТаблицы Из ТаблицаДвиженийДокумента Цикл							
			
			Если ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
				НоваяСтрока = Объект.ОсновныеСредства.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТаблицы);
				НоваяСтрока.ОсновноеСредство = Объект.ОсновноеСредство;
				НоваяСтрока.СоставОСМСФОСтарый = ПредопределенноеЗначение("Справочник.бит_му_СоставОС.ВНА_РСБУ");
				НоваяСтрока.СоставОСМСФОНовый = ПредопределенноеЗначение("Справочник.бит_му_СоставОС.ВНА_РСБУ");
				НоваяСтрока.СуммаПостоянная  = НоваяСтрока.Сумма;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Объект.ОсновноеСредствоICLL) Тогда
				НоваяСтрока = Объект.ОсновныеСредства.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТаблицы);
				НоваяСтрока.ОсновноеСредство = Объект.ОсновноеСредствоICLL;
				Если ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
					НоваяСтрока.Сумма            = 0;
				КонецЕсли;
				НоваяСтрока.СоставОСМСФОСтарый = ПредопределенноеЗначение("Справочник.бит_му_СоставОС.ВНА_РСБУ");
				НоваяСтрока.СоставОСМСФОНовый = ПредопределенноеЗначение("Справочник.бит_му_СоставОС.ВНА_РСБУ");
				НоваяСтрока.СуммаПостоянная  = НоваяСтрока.Сумма;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
КонецФункции

// бит_DKravchenko Процедура - обработчик события "ОбработкаВыбора" формы.
//
&НаКлиенте
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	ЗаменятьИдентичные = Ложь;
		
	Если ТипЗнч(ЗначениеВыбора) = Тип("Структура") Тогда
			
			Если ЗначениеВыбора.Свойство("Действие") Тогда
				
				ТаблицаДанных = ЗначениеВыбора.Данные;
				
				Если ВРег(ЗначениеВыбора.Действие) = ВРег("Загрузить") Тогда
					
					Если Объект.ОсновныеСредства.Количество()>0 Тогда
						Ответ = Вопрос("Табличная часть будет очищена. Продолжить?", РежимДиалогаВопрос.ДаНет,5,КодВозвратаДиалога.Нет); 
						Если Ответ = КодВозвратаДиалога.Нет ИЛИ Ответ = КодВозвратаДиалога.Таймаут Тогда
							Возврат;
						КонецЕсли;
						Объект.ОсновныеСредства.Очистить();
					КонецЕсли; 
				Иначе
					Если Объект.ОсновныеСредства.Количество()>0 Тогда
						Ответ = Вопрос("При наличие в табличной части документов, выбранных в подборе, заменять их?", РежимДиалогаВопрос.ДаНет,10,КодВозвратаДиалога.Нет); 
						ЗаменятьИдентичные = Ответ = КодВозвратаДиалога.Да;
					КонецЕсли; 
				КонецЕсли;
				
				//СтруктураПараметров = бит_му_ОбщегоНазначения.ПодготовитьСтруктуруПараметровДляПодбораСчетовМУ(Организация,Дата);
				//МассивДокументовБУ  =   ТаблицаДанных.ВыгрузитьКолонку("ДокументБУ");
				МассивДокументовБУ = Новый Массив;
				Для Каждого текЭлемент Из ТаблицаДанных.ПереченьОбъектов Цикл
					МассивДокументовБУ.Добавить(текЭлемент.ДокументБУ);
				КонецЦикла;
				
				ОбработкаВыбора_Сервер(МассивДокументовБУ, ЗаменятьИдентичные);
				
			КонецЕсли; // в структуре есть поле действие 
			
		КонецЕсли; // это структура
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи);;	
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ


// Процедура разрешения/запрещения редактирования номера документа
//
&НаКлиенте
Процедура ДействияФормыРедактироватьНомер(Команда)
			
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "Нажатие" кнопки "ЗаполнитьПараметрыДляТекущегоОС"
// коммандной панели "КоманднаяПанельОсновныеСредства".
//
&НаКлиенте
Процедура КоманднаяПанельОсновныеСредстваЗаполнитьПараметрыДляТекущегоОС(Команда)
	
	ТекущаяСтрока = Элементы.ОсновныеСредства.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
        Предупреждение("Для заполнения параметров необходимо выбрать строку с ОС
                       |для которого необходимо заполнить параметры.");
        Возврат;
    КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.ОсновноеСредство) Тогда
		Возврат;
	КонецЕсли;
	
	// Получим параметры по ОС.
	ПолучитьПараметрыОС(ТекущаяСтрока,, Истина);
	
КонецПроцедуры

&НаСервере
Функция КоманднаяПанельОсновныеСредстваЗаполнитьПараметрыДляВсехОС_Сервер(СписокОС)
	
	СписокОС = Объект.ОсновныеСредства.Выгрузить().ВыгрузитьКолонку("ОсновноеСредство");
	ОбщегоНазначенияБПВызовСервера.УдалитьПовторяющиесяЭлементыМассива(СписокОС, Истина);
КонецФункции


// бит_DKravchenko Процедура - обработчик события "Нажатие" кнопки "ЗаполнитьПараметрыДляВсехОС"
// коммандной панели "КоманднаяПанельОсновныеСредства".
//
&НаКлиенте
Процедура КоманднаяПанельОсновныеСредстваЗаполнитьПараметрыДляВсехОС(Команда)
	Перем СписокОС;
	
	КоманднаяПанельОсновныеСредстваЗаполнитьПараметрыДляВсехОС_Сервер(СписокОС);
	
	Если СписокОС.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ОсновныеСредства.Количество() <> 0 Тогда
		
		Ответ = Вопрос("Параметры в табличной части будут перезаполнены. Продолжить?"
					  ,РежимДиалогаВопрос.ДаНет
					  ,30
					  ,КодВозвратаДиалога.Нет); 
		
		Если Не Ответ = КодВозвратаДиалога.Да Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	// Получим параметры по ОС.
	ПолучитьПараметрыОС(СписокОС,, Истина);
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "Нажатие" кнопки "Подбор"
// коммандной панели "КоманднаяПанельОсновныеСредства".
//
&НаКлиенте
Процедура КоманднаяПанельОсновныеСредстваПодбор(Команда)
	Если ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
		ОбъектСтроительства = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредство, "Объект");
	ИначеЕсли ЗначениеЗаполнено(Объект.ОсновноеСредствоICLL) Тогда
		ОбъектСтроительства = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредствоICLL, "Объект");
	Иначе
		Предупреждение("Заполните ОС или ОСICLL");
		Возврат;
	КонецЕсли;
	
	стПараметры = Новый Структура;
	стПараметры.Вставить("ДатаНачала"		, '19800101');
	стПараметры.Вставить("ДатаОкончания"	, КонецМесяца(Объект.Дата));
	стПараметры.Вставить("Режим"			, ПредопределенноеЗначение("Перечисление.бит_му_РежимыПодбораВНА.бит_КомплектацияОС"));
	стПараметры.Вставить("Организация"	, Объект.Организация);
	стПараметры.Вставить("МОЛ"			, Объект.МОЛ);
	стПараметры.Вставить("Местонахождение", Объект.Подразделение);
	стПараметры.Вставить("ОбъектСтроительства"		, ОбъектСтроительства);
	стПараметры.Вставить("МетодНачисленияАмортизации", Объект.бит_МетодНачисленияАмортизации);
	
	ФормаПодбора = ПолучитьФорму("Обработка.бит_му_ПодборВНАПринятиеМодернизация.Форма", стПараметры, ЭтаФорма);
	ФормаПодбора.ЗакрыватьПриВыборе = Ложь;
		
	//Если НЕ ФормаПодбора.Открыта() Тогда
	//	
	//	//Если ВидОперации = Перечисления.бит_му_ВидыОперацийМодернизацияОС.ОсновныеСредства Тогда
	//	//	ВидКласса = Перечисления.бит_му_ВидыКлассовОС.ОсновныеСредства;
	//	//Иначе
	//	//	ВидКласса = Перечисления.бит_му_ВидыКлассовОС.ИнвестиционнаяСобственность;
	//	//КонецЕсли;
	//	
	//	ФормаПодбора.Объект.Режим           = ПредопределенноеЗначение("Перечисление.бит_му_РежимыПодбораВНА.бит_КомплектацияОС");
	//	ФормаПодбора.Объект.ДатаНачала      = НачалоМесяца(Объект.Дата);
	//	ФормаПодбора.Объект.ДатаОкончания   = КонецМесяца(Объект.Дата);
	//	//БИТ Тртилек 02.07.2012
	//	ФормаПодбора.Объект.ДатаНачала      = '19800101';
		ФормаПодбора.Элементы.ДатаНачала.Доступность = ЛОЖЬ;
	//	Если ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
	//		ФормаПодбора.Объект.ОбъектСтроительства = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредство, "Объект");
	//	ИначеЕсли ЗначениеЗаполнено(Объект.ОсновноеСредствоICLL) Тогда
	//		ФормаПодбора.Объект.ОбъектСтроительства = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредствоICLL, "Объект");
	//	Иначе
	//		Предупреждение("Заполните ОС или ОСICLL");
	//		Возврат;
	//	КонецЕсли;
	//	///БИТ Тртилек
	//	ФормаПодбора.Объект.Организация     = Объект.Организация;
	//	ФормаПодбора.Объект.МОЛ             = Объект.МОЛ;
	//	ФормаПодбора.Объект.Местонахождение = Объект.Подразделение;;
	//	//ФормаПодбора.Объект.ВидКласса 		 = ВидКласса;
	//	
	//КонецЕсли;
	
	ФормаПодбора.Открыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

// Процедура - обработчик события "ПриИзменении" поля ввода "Дата"
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	ДобавитьВКэш("Дата");
КонецПроцедуры

&НаСервере
Функция ОрганизацияПриИзменении_Сервер()
	// Проверим принадлежность подразделения к выбранной организации.
	бит_ОбщегоНазначения.ПроверитьПринадлежностьАналитики(Объект
	                                                      ,
														  ,"Подразделение"
														  ,"Владелец"
														  ,"Организация"
														  ,"СправочникСсылка.ПодразделенияОрганизаций"
														  ,"В документе"
														  ,"Изменение значения реквизита Организация");
	
	ДобавитьВКэш("Организация");
	
	// Заполним валюту МСФО.
	ЗаполнитьВалютуМСФО();
КонецФункции


// Процедура - обработчик события "ПриИзменении" поля ввода "Организация"
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Не мКэшРеквизитовФормы.Организация = Объект.Организация
		И Объект.ОсновныеСредства.Количество() > 0 Тогда
		
		Ответ = Вопрос("Табличная часть ""Основные средства"" будет очищена. Продолжить?"
					  ,РежимДиалогаВопрос.ДаНет
					  ,30
					  ,КодВозвратаДиалога.Нет); 
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.ОсновныеСредства.Очистить();
		Иначе
			ИзвлечьИзКэша("Организация");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОрганизацияПриИзменении_Сервер();
	ОбновлениеОтображения();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ "ОсновныеСредства"

// бит_DKravchenko Процедура - обработчик события "ПриАктивизацииСтроки" 
// табличного поля "ОсновныеСредства".
//
&НаКлиенте
Процедура ОсновныеСредстваПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрока = Элементы.ОсновныеСредства.ТекущиеДанные;
	
	//бит_РаботаСДиалогами.ВывестиИменаСубконтоВШапке(Элементы.ОсновныеСредства.ПодчиненныеЭлементы
	//											   ,ТекущаяСтрока
	//											   ,"Субконто"
	//											   ,"Субконто"
	//											   ,мКоличествоСубконтоМУ);	
	
КонецПроцедуры

&НаСервере
Процедура ОсновныеСредстваПриПолученииДанных(Элемент, ОформленияСтрок)
	
	//КолонкиОС = ЭлементыФормы.ОсновныеСредства.Колонки;
	//ЕстьКолонкаИН 			= КолонкиОС.ИнвентарныйНомер.Видимость;
	//ЕстьКолонкаОстСтоимость = КолонкиОС.ОстСтоимость.Видимость;
	//ЕстьКолонкаОстСрок 		= КолонкиОС.ОстСрокИспользования.Видимость;
	//ЕстьКолонкаОстОбъем		= КолонкиОС.ОстОбъемПродукцииРабот.Видимость;
	
    //Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		
		//ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		
		//Если ЕстьКолонкаИН Тогда
			
			// Получим инвентарный номер текущего ОС.
			//ТекИнвентарныйНомер = бит_му_ВНА.ПолучитьСоответствиеОС_ИнвентарныйНомер(СоответствиеОС_ИнвентарныйНомер
																					//,ДанныеСтроки.ОсновноеСредство
																					//,Организация);
																					
			//ОформлениеСтроки.Ячейки.ИнвентарныйНомер.УстановитьТекст(ТекИнвентарныйНомер);
			
		//КонецЕсли;
		
		//Если ЕстьКолонкаОстСтоимость Тогда
			
			// Получим остаточную стоимость ОС.
			//ОстСтоимость = (ДанныеСтроки.Стоимость + ДанныеСтроки.СуммаМодернизации 
						    //- ДанныеСтроки.СуммаФактическогоОбесценения - ДанныеСтроки.Амортизация);
			
			//ОформлениеСтроки.Ячейки.ОстСтоимость.УстановитьТекст(СокрЛ(Формат(ОстСтоимость, "ЧЦ=15;ЧДЦ=2")));
			
		//КонецЕсли;
		
		//Если ЕстьКолонкаОстСрок Тогда
			
			// Получим остаточный срок использования ОС.
			//ОстСрокИспользования = (ДанныеСтроки.СрокПолезногоИспользования - ДанныеСтроки.ФактСрокИспользования);
			
			//ОформлениеСтроки.Ячейки.ОстСрокИспользования.УстановитьТекст(ОстСрокИспользования);
			
		//КонецЕсли;
		
		//Если ЕстьКолонкаОстОбъем Тогда
			
			// Получим остаточный объем продукции работ ОС.
			//ОстОбъемПродукцииРабот = (ДанныеСтроки.ОбъемПродукцииРабот - ДанныеСтроки.ФактОбъемПродукцииРабот);
			
			//ОформлениеСтроки.Ячейки.ОстОбъемПродукцииРабот.УстановитьТекст(СокрЛ(Формат(ОстОбъемПродукцииРабот, "ЧЦ=15;ЧДЦ=3")));
			
		//КонецЕсли;
		
		//КоличествоСубконто = ДанныеСтроки.СчетНезавершенногоСтроительства.ВидыСубконто.Количество();
		
		// Установим доступность субконто.
		//Для Ном = 1 По мКоличествоСубконтоМУ Цикл
			
			//ИмяРеквизитаСубконто = "Субконто" + Ном;
			
			//Если Ном > КоличествоСубконто Тогда
				//ОформлениеСтроки.Ячейки[ИмяРеквизитаСубконто].ТолькоПросмотр = Истина;
				//ОформлениеСтроки.Ячейки[ИмяРеквизитаСубконто].ЦветФона       = мЦветТолькоПросмотр;
			//КонецЕсли;
			
		//КонецЦикла; // по количеству субконто МУ
		
		// Установим доступность параметров ОС зависимых от метода ничасления амортизации.
		//МассивНедоступныхПараметров = СформироватьМассивНедоступныхПараметров(ДанныеСтроки, Истина);
		
		//Для Каждого ТекИмяПараметра Из МассивНедоступныхПараметров Цикл
			//ОформлениеСтроки.Ячейки[ТекИмяПараметра].ТолькоПросмотр = Истина;
			//ОформлениеСтроки.Ячейки[ТекИмяПараметра].ЦветФона       = мЦветТолькоПросмотр;
		//КонецЦикла;
		
    //КонецЦикла; 
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ТАБЛИЧНОГО ПОЛЯ "ОсновныеСредства"

// бит_DKravchenko Процедура - обработчик события "ПриИзменении" поля ввода "ОсновноеСредство" 
// табличного поля "ОсновныеСредства".
//
&НаКлиенте
Процедура ОсновныеСредстваОсновноеСредствоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ОсновныеСредства.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено 
		Или Не ЗначениеЗаполнено(ТекущаяСтрока.ОсновноеСредство) Тогда
		Возврат;
	КонецЕсли;
	
	// Получим параметры по ОС.
	ПолучитьПараметрыОС(ТекущаяСтрока);
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "ПриИзменении" поля ввода "МетодНачисленияАмортизации" 
// табличного поля "ОсновныеСредства".
//
&НаКлиенте
Процедура ОсновныеСредстваМетодНачисленияАмортизацииПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ОсновныеСредства.ТекущиеДанные;
	
	// Очистим параметры ОС недоступные для выбранного метода ничасления амортизации.
	ОчиститьНедоступныеПараметрыОС_Вызов_Функции(ТекущаяСтрока);
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "ПриИзменении" поля ввода "СчетНезавершенногоСтроительства" 
// табличного поля "ОсновныеСредства".
//
&НаКлиенте
Процедура ОсновныеСредстваСчетНезавершенногоСтроительстваПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ОсновныеСредства.ТекущиеДанные;
	ПриИзмененииСчетаНезавершенногоСтроительства(ТекущаяСтрока.ПолучитьИдентификатор());
	
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "ПриИзменении" полей Субконто
// табличного поля "ОсновныеСредства".
//
&НаКлиенте
Процедура ОсновныеСредстваСубконтоПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ОсновныеСредства.ТекущиеДанные;
	
	// Обработаем изменение субконто.
	//бит_РаботаСДиалогами.ОбработатьИзменениеСубконтоВСтрокеТЧ(ТекущаяСтрока, Элемент, "Субконто", мКоличествоСубконтоМУ);
	СписокПараметров = бит_му_ОбщегоНазначения.ПодготовитьПараметрыДляВыбораСубконто(ТекущаяСтрока
																					,"Субконто"
																					,мКоличествоСубконтоМУ
																					,Объект.Ссылка.Пустая());
	
	бит_му_ОбщегоНазначения.ОбработатьВыборСубконто(Элемент, Истина, Объект.Организация, СписокПараметров);
КонецПроцедуры

// бит_DKravchenko Процедура - обработчик события "НачалоВыбора" полей Субконто
// табличного поля "ОсновныеСредства".
//
&НаКлиенте
Процедура ОсновныеСредстваСубконтоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока 	 = Элементы.ОсновныеСредства.ТекущиеДанные;
	СписокПараметров = бит_му_ОбщегоНазначения.ПодготовитьПараметрыДляВыбораСубконто(ТекущаяСтрока
																					,"Субконто"
																					,мКоличествоСубконтоМУ
																					,Объект.Ссылка.Пустая());
	
	бит_му_ОбщегоНазначения.ОбработатьВыборСубконто(Элемент, СтандартнаяОбработка, Объект.Организация, СписокПараметров);
	
КонецПроцедуры

// БИТ Тртилек 02.07.2012 Процедура - обработчик события "ПриИзменении" поля ввода "бит_ОсновноеСредство" 
&НаКлиенте
Процедура бит_ОсновноеСредствоПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не мКэшРеквизитовФормы.ОсновноеСредство = Объект.ОсновноеСредство
		И Объект.ОсновныеСредства.Количество() > 0 Тогда
		
		Ответ = Вопрос("Табличная часть ""Основные средства"" будет очищена. Продолжить?"
						,РежимДиалогаВопрос.ДаНет
						,30
						,КодВозвратаДиалога.Нет); 
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.ОсновныеСредства.Очистить();
			ОбновлениеОтображения();
		Иначе
			ИзвлечьИзКэша("ОсновноеСредство");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредство, "Объект") = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредствоICLL, "Объект") И ЗначениеЗаполнено(Объект.ОсновноеСредство) И ЗначениеЗаполнено(Объект.ОсновноеСредствоICLL) Тогда
				
		Предупреждение("Объект в основном средстве должен совпадать с объектом в основном средстве ICLL. Перевыберите ОС.", 6);
		ИзвлечьИзКэша("ОсновноеСредство");
		Возврат;
		
	КонецЕсли;
	
	МассивОС = Объект.ОсновноеСредство;
	
	Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
		Сообщить("Не выбрана организация - данные по основному средству не были заполнены.", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;
	
	//СтруктураПараметровУчета = Новый Структура;
	//СтруктураПараметровУчета.Вставить("СрокПолезногоИспользования_Старый");
	//СтруктураПараметровУчета.Вставить("МетодНачисленияАмортизации_Старый");
	//СтруктураПараметровУчета.Вставить("КоэффициентУскорения_Старый");
	//СтруктураПараметровУчета.Вставить("ОбъемПродукцииРабот_Старый");
	//СтруктураПараметровУчета.Вставить("ЛиквидационнаяСтоимость_Старый");
	//СтруктураПараметровУчета.Вставить("СрокПолезногоИспользования");
	//СтруктураПараметровУчета.Вставить("МетодНачисленияАмортизации");
	//СтруктураПараметровУчета.Вставить("КоэффициентУскорения");
	//СтруктураПараметровУчета.Вставить("ОбъемПродукцииРабот");
	//СтруктураПараметровУчета.Вставить("ЛиквидационнаяСтоимость");
	//СтруктураПараметровУчета.Вставить("ФактСрокИспользования");
	//СтруктураПараметровУчета.Вставить("ФактОбъемПродукцииРабот");
	//СтруктураПараметровУчета.Вставить("Стоимость");
	//СтруктураПараметровУчета.Вставить("Амортизация");
	//СтруктураПараметровУчета.Вставить("СуммаМодернизации");
	//СтруктураПараметровУчета.Вставить("СуммаФактическогоОбесценения");	
	//СтруктураПараметровУчета.Вставить("ОсновноеСредство", ОсновноеСредство);	
	//															
	//// Заполним данные по основным средствам.
	//ЗаполнитьДанныеПоОсновнымСредствам(МассивОС, СтруктураПараметровУчета, ЛОЖЬ);
	//
	//бит_СрокПолезногоИспользованияСтар  = СтруктураПараметровУчета.СрокПолезногоИспользования_Старый;
	//бит_НовыйСрокИспользования          = СтруктураПараметровУчета.СрокПолезногоИспользования;
	//бит_ФактическийСрокИспользования    = СтруктураПараметровУчета.ФактСрокИспользования;
	//бит_ОставшийсяСрокИспользования     = СтруктураПараметровУчета.СрокПолезногоИспользования - СтруктураПараметровУчета.ФактСрокИспользования;
	//бит_Стоимость                       = СтруктураПараметровУчета.Стоимость;
	//бит_ФактическаяАмортизация          = СтруктураПараметровУчета.Амортизация;
	//бит_СуммаМодернизации               = СтруктураПараметровУчета.СуммаМодернизации;
	//бит_СуммаФактическогоОбесценения    = СтруктураПараметровУчета.СуммаФактическогоОбесценения;
	//бит_МетодНачисленияАмортизации      = СтруктураПараметровУчета.МетодНачисленияАмортизации_Старый;
	//бит_НовыйМетодНачисленияАмортизации = СтруктураПараметровУчета.МетодНачисленияАмортизации;
	//бит_КоэффициентУскорения            = СтруктураПараметровУчета.КоэффициентУскорения_Старый;
	//бит_НовыйКоэффициентУскорения       = СтруктураПараметровУчета.КоэффициентУскорения;
	//бит_ЛиквидационнаяСтоимость         = СтруктураПараметровУчета.ЛиквидационнаяСтоимость_Старый;
	//бит_НоваяЛиквидационнаяСтоимость    = СтруктураПараметровУчета.ЛиквидационнаяСтоимость;
	//бит_Инвентарник                     = ОсновноеСредство.Код;
	//бит_ОстаточнаяСтоимость             = СтруктураПараметровУчета.Стоимость-СтруктураПараметровУчета.Амортизация+?(СтруктураПараметровУчета.СуммаМодернизации = Неопределено, 0, СтруктураПараметровУчета.СуммаМодернизации);
	
КонецПроцедуры

&НаКлиенте
Процедура бит_ОсновноеСредствоНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Тест = 0;
КонецПроцедуры

// БИТ Тртилек 02.07.2012 Процедура - обработчик события "ПриИзменении" поля сумма
&НаКлиенте
Процедура ОсновныеСредстваСуммаПриИзменении(Элемент)
	
	Если Элементы.ОсновныеСредства.ТекущиеДанные.ОсновноеСредство = Объект.ОсновноеСредствоICLL Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("НомерСтрокиДвижений", Элементы.ОсновныеСредства.ТекущиеДанные.НомерСтрокиДвижений);
		ПараметрыОтбора.Вставить("ДокументРСБУ", Элементы.ОсновныеСредства.ТекущиеДанные.ДокументРСБУ);
		ПараметрыОтбора.Вставить("ОсновноеСредство", Объект.ОсновноеСредство);
		НайденныеСтроки = Объект.ОсновныеСредства.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 1 Тогда
			НайденныеСтроки[0].Сумма = НайденныеСтроки[0].СуммаПостоянная - Элементы.ОсновныеСредства.ТекущиеДанные.Сумма; 
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновноеСредствоICLLПриИзменении(Элемент)
	
	Если Не мКэшРеквизитовФормы.ОсновноеСредствоICLL = Объект.ОсновноеСредствоICLL
		И Объект.ОсновныеСредства.Количество() > 0 Тогда
		
		Ответ = Вопрос("Табличная часть ""Основные средства"" будет очищена. Продолжить?"
						,РежимДиалогаВопрос.ДаНет
						,30
						,КодВозвратаДиалога.Нет); 
		
		Если Ответ = КодВозвратаДиалога.Да Тогда
			Объект.ОсновныеСредства.Очистить();
		Иначе
			ИзвлечьИзКэша("ОсновноеСредствоICLL");
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредство, "Объект") = ИнтеграцияС1СДокументооборотВызовСервера.ЗначениеРеквизитаОбъекта(Объект.ОсновноеСредствоICLL, "Объект") И ЗначениеЗаполнено(Объект.ОсновноеСредствоICLL) И ЗначениеЗаполнено(Объект.ОсновноеСредство) Тогда
				
		Предупреждение("Объект в основном средстве ICLL должен совпадать с объектом в основном средстве. Перевыберите ОСICLL.", 6);
		ИзвлечьИзКэша("ОсновноеСредствоICLL");
		Возврат;
		
	КонецЕсли;

	
КонецПроцедуры

&НаКлиенте
Процедура ОсновныеСредстваПередУдалением(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ОсновноеСредство = Объект.ОсновноеСредствоICLL Тогда
		
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("НомерСтрокиДвижений", Элемент.ТекущиеДанные.НомерСтрокиДвижений);
		ПараметрыОтбора.Вставить("ДокументРСБУ", Элемент.ТекущиеДанные.ДокументРСБУ);
		ПараметрыОтбора.Вставить("ОсновноеСредство", Объект.ОсновноеСредство);
		НайденныеСтроки = Объект.ОсновныеСредства.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 1 Тогда
			НайденныеСтроки[0].Сумма = НайденныеСтроки[0].СуммаПостоянная; 
		КонецЕсли;
		
	ИначеЕсли Элемент.ТекущиеДанные.ОсновноеСредство = Объект.ОсновноеСредство Тогда

		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("НомерСтрокиДвижений", Элемент.ТекущиеДанные.НомерСтрокиДвижений);
		ПараметрыОтбора.Вставить("ДокументРСБУ", Элемент.ТекущиеДанные.ДокументРСБУ);
		ПараметрыОтбора.Вставить("ОсновноеСредство", Объект.ОсновноеСредствоICLL);
		НайденныеСтроки = Объект.ОсновныеСредства.НайтиСтроки(ПараметрыОтбора);
		Если НайденныеСтроки.Количество() = 1 Тогда
			НайденныеСтроки[0].Сумма = Элемент.ТекущиеДанные.СуммаПостоянная; 
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДанныеПоОсновнымСредствам_Вызов_Функции(СписокОС, СтрокаТабличнойЧастиОС=Неопределено, НеИзменяемыеПараметры)
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ЗаполнитьДанныеПоОсновнымСредствам(СписокОС, СтрокаТабличнойЧастиОС, НеИзменяемыеПараметры);
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция СинхронизироватьРеквизитыСтрокиОС_Вызов_Функции(ТекущаяСтрока, ИмяСубконто)
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.СинхронизироватьРеквизитыСтрокиОС(ТекущаяСтрока, ИмяСубконто);
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаСервере
Функция ПолучитьДвиженияПоХозрасчетномуРегистру_Вызов_Функции(МассивДокументовБУ)
	_объект=РеквизитФормыВЗначение("Объект");
	результат = _объект.ПолучитьДвиженияПоХозрасчетномуРегистру(МассивДокументовБУ);
	ЗначениеВРеквизитФормы(_объект, "Объект");
	Возврат результат;
КонецФункции

&НаСервере
Функция ОчиститьНедоступныеПараметрыОС_Вызов_Функции(ТекущаяСтрока)
	_объект=РеквизитФормыВЗначение("Объект");
	_объект.ОчиститьНедоступныеПараметрыОС(ТекущаяСтрока);
	ЗначениеВРеквизитФормы(_объект, "Объект");
КонецФункции

&НаКлиенте
Процедура ОсновныеСредстваПриИзменении(Элемент)
	ОбновлениеОтображения();
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

//СоответствиеОС_ИнвентарныйНомер = Новый Структура();
мЦветТолькоПросмотр 			= Новый Цвет(225,225,225);

// Зададим имена реквизитов, подлежащих кешированию
мКэшРеквизитовФормы = Новый Структура("Дата, Организация, ОсновноеСредство, ОсновноеСредствоICLL");