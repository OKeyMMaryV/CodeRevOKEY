#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Функция определяет, что обработка является обработкой доставки оповещений.
// 
// Возвращаемое значение:
//   Булево
// 
Функция ЭтоОбработкаДоставкиОповещений() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Процедура проверяет корретность структуры сообщения. В случае ошибки устанавливается Отказ = Истина;
// 
Процедура СтруктураСообщенияКорректна(Сообщение,Отказ,ПротоколОтправки = "") Экспорт
	
	// Приведем строковое описание типа текста к системному перечислению.
	Если НЕ Сообщение.Свойство("ТипТекстаСообщения")
		ИЛИ НЕ ЗначениеЗаполнено(Сообщение.ТипТекстаСообщения) Тогда
		
		ТипТекстаСообщения = ТипТекстаПочтовогоСообщения.ПростойТекст;
	Иначе
		
		Для Каждого ТекущийТипТекста Из ТипТекстаПочтовогоСообщения Цикл
			
			Если Строка(ТекущийТипТекста) = Сообщение.ТипТекстаСообщения Тогда
				ТипТекстаСообщения = ТекущийТипТекста;
				
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Сообщение.Вставить("ТипТекстаСообщения", ТипТекстаСообщения);
	
КонецПроцедуры

// Процедура проверяет корретность настроек доставки. В случае ошибки устанавливается Отказ = Истина;
// 
Процедура СтруктураНастроекДоставкиКорректна(Настройка,Отказ,ПротоколОтправки = "") Экспорт
	
КонецПроцедуры

// Процедура проверяет корретность структуры параметров. В случае ошибки устанавливается Отказ = Истина;
// 
Процедура СтруктураПараметровКорректна(Настройка,Отказ,ПротоколОтправки = "") Экспорт
	
	Если НЕ Настройка.Свойство("АдресПолучателя") 
		 ИЛИ НЕ ЗначениеЗаполнено(Настройка.АдресПолучателя) Тогда
	
		Отказ = Истина;
		ПротоколОтправки = "Не указан адрес получателя!";
		
		
	КонецЕсли; 
	
	
КонецПроцедуры

// Функция возвращает настройки доставки по умолчанию.
// 
// Возвращаемое значение:
//   РезСтруктура   - Структура
// 
Функция НастройкиПоУмолчанию() Экспорт

	РезСтруктура = Новый Структура;
	РезСтруктура.Вставить("ПортSMTP"          ,25);
	РезСтруктура.Вставить("SMTPАутентификация","БезАутентификации");
	РезСтруктура.Вставить("ПортPOP3"          ,110);
	РезСтруктура.Вставить("POPАутентификация" ,"Обычная");
	РезСтруктура.Вставить("ВремяОжидания"     ,30);

	Возврат РезСтруктура;
	
КонецФункции // НастройкиПоУмолчанию()

// Процедура выполняет отправку сообщений;
// 
// Параметры:
//  СообщениеСтруктура  - Структура.
//  НастройкиДоставки   - Структура.
//  СтруктураПараметров - Структура.
//  ПротоколОтправки    - Строка.
// 
Функция ОтправитьСообщение(СообщениеСтруктура, НастройкиДоставки, СтруктураПараметров,ПротоколОтправки="") Экспорт
	
	флДействиеВыполнено = Ложь;			
	Отказ = Ложь;
	
	// Выполним проверки настроек 
	СтруктураСообщенияКорректна(СообщениеСтруктура,Отказ,ПротоколОтправки);	
	СтруктураНастроекДоставкиКорректна(НастройкиДоставки,Отказ,ПротоколОтправки); 
	СтруктураПараметровКорректна(СтруктураПараметров,Отказ,ПротоколОтправки); 
	
	Если НЕ Отказ Тогда
		
		// Сформируем почтовый профиль
		ИПП 					= Новый ИнтернетПочтовыйПрофиль;
		ИПП.АдресСервераSMTP 	= НастройкиДоставки.АдресSMTP;   
		ИПП.ПортSMTP 			= НастройкиДоставки.ПортSMTP;
		Если НЕ ПустаяСтрока(СокрЛП(НастройкиДоставки.SMTPАутентификация)) Тогда
			
			ИПП.АутентификацияSMTP 	= СпособSMTPАутентификации[СокрЛП(НастройкиДоставки.SMTPАутентификация)];
			
		КонецЕсли; 
		ИПП.ПользовательSMTP 	= НастройкиДоставки.ПользовательSMTP;
		ИПП.ПарольSMTP 			= НастройкиДоставки.ПарольSMTP;
		Если НастройкиДоставки.Свойство("ИспользоватьSSLSMTP") Тогда
			
			ИПП.ИспользоватьSSLSMTP = НастройкиДоставки.ИспользоватьSSLSMTP;
			
		КонецЕсли; 
		Если НастройкиДоставки.Свойство("ТолькоЗащищеннаяАутентификацияSMTP") Тогда
			
			ИПП.ТолькоЗащищеннаяАутентификацияSMTP = НастройкиДоставки.ТолькоЗащищеннаяАутентификацияSMTP;
			
		КонецЕсли; 		
		
		ИПП.АдресСервераPOP3    = НастройкиДоставки.АдресPOP3;
		ИПП.ПортPOP3            = НастройкиДоставки.ПортPOP3;
		Если НЕ ПустаяСтрока(СокрЛП(НастройкиДоставки.POPАутентификация)) Тогда
			
			ИПП.АутентификацияPOP3  = СпособPOP3Аутентификации[СокрЛП(НастройкиДоставки.POPАутентификация)];
			
		КонецЕсли; 
		ИПП.Пользователь        = НастройкиДоставки.ПользовательPOP3;
		ИПП.Пароль              = НастройкиДоставки.ПарольPOP3;
		
		Если НастройкиДоставки.Свойство("ИспользоватьSSLPOP3") Тогда
			
			ИПП.ИспользоватьSSLPOP3 = НастройкиДоставки.ИспользоватьSSLPOP3;
			
		КонецЕсли; 
		Если НастройкиДоставки.Свойство("ТолькоЗащищеннаяАутентификацияPOP3") Тогда
			
			ИПП.ТолькоЗащищеннаяАутентификацияPOP3 = НастройкиДоставки.ТолькоЗащищеннаяАутентификацияPOP3;                         
			
		КонецЕсли; 		
		
		// Создадим сообщение 
		Сообщение = Новый ИнтернетПочтовоеСообщение; 
		
		Если НастройкиДоставки.Свойство("КодировкаСообщения") Тогда
			Сообщение.Кодировка = НастройкиДоставки.КодировкаСообщения;
		КонецЕсли;
		
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-02-01 (#2975)
		//Сообщение.Отправитель.Адрес = НастройкиДоставки.EMailАдресОтправителя;
		//Сообщение.ОбратныйАдрес.Добавить(НастройкиДоставки.EMailАдресОтправителя);
		//Сообщение.Получатели.Добавить(СтруктураПараметров.АдресПолучателя);  		
		//Заменено на:
		Если СтруктураПараметров.Свойство("EMailАдресОтправителя") Тогда 				
			Сообщение.Отправитель.Адрес = СтруктураПараметров.EMailАдресОтправителя;
			Сообщение.ОбратныйАдрес.Добавить(СтруктураПараметров.EMailАдресОтправителя);
			Сообщение.Копии.Добавить(СтруктураПараметров.EMailАдресОтправителя);
		Иначе
			Сообщение.Отправитель.Адрес = НастройкиДоставки.EMailАдресОтправителя;
			Сообщение.ОбратныйАдрес.Добавить(НастройкиДоставки.EMailАдресОтправителя);
		КонецЕсли;
		
		Если СтруктураПараметров.Свойство("ИнициаторEmail") Тогда
			Сообщение.Копии.Добавить(СтруктураПараметров.ИнициаторEmail);
		КонецЕсли;
		
		//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941)
		ВложенияНеОтмеченныеКОтправке = Новый Массив;
		//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)
		
		Если СтруктураПараметров.Свойство("ИдентификаторДляВложений") 
			 //ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-07-18 (#3036)
			 И ЗначениеЗаполнено(СтруктураПараметров.ИдентификаторДляВложений)
			 //ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-07-18 (#3036)
		Тогда 
		
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-07-18 (#3036)
			//пНаборВременныхФайлов = РегистрыСведений.ок_ВременныеФайлыПисем.СоздатьНаборЗаписей();
			//пНаборВременныхФайлов.Отбор.Идентификатор.Установить(СтруктураПараметров.ИдентификаторДляВложений);
			//пНаборВременныхФайлов.Прочитать();
			//Если пНаборВременныхФайлов.Выбран() Тогда 
			//	пИндексНабора = пНаборВременныхФайлов.Количество()-1;
			//	Пока пИндексНабора>=0 Цикл 
			//		Сообщение.Вложения.Добавить(пНаборВременныхФайлов[пИндексНабора].Файл.Получить(), пНаборВременныхФайлов[пИндексНабора].ПолноеИмяФайла);										
			//		пНаборВременныхФайлов.Удалить(пИндексНабора);
			//		пИндексНабора = пИндексНабора - 1;
			//	КонецЦикла;
			//	пНаборВременныхФайлов.Записать();
			//КонецЕсли;
			//Заменено на:
			пЗапрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ок_ВременныеФайлыПисем.Идентификатор КАК Идентификатор,
			|	ок_ВременныеФайлыПисем.ПолноеИмяФайла КАК ПолноеИмяФайла,
			|	ок_ВременныеФайлыПисем.Файл КАК Файл
			//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941)
			|	, ок_ВременныеФайлыПисем.КОтправке КАК КОтправке
			//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)
			|ИЗ
			|	РегистрСведений.ок_ВременныеФайлыПисем КАК ок_ВременныеФайлыПисем
			|ГДЕ
			|	ок_ВременныеФайлыПисем.Идентификатор = &Идентификатор");
			пЗапрос.УстановитьПараметр("Идентификатор", СтруктураПараметров.ИдентификаторДляВложений);
			пРезультат = пЗапрос.Выполнить();
			Если НЕ пРезультат.Пустой() Тогда 
				МДРСВрФ = Метаданные.РегистрыСведений.ок_ВременныеФайлыПисем;
				Выборка = пРезультат.Выбрать();
				
				//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941)
				ОтправлятьВсеФайлы = (Выборка.НайтиСледующий(Истина, "КОтправке") = Ложь);
				Выборка.Сбросить();
				//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)
				
				Пока Выборка.Следующий() Цикл 
					
					пДвоичныеДанныеДляОтправки = Выборка.Файл.Получить();
					
					Если ТипЗнч(пДвоичныеДанныеДляОтправки) = Тип("ДвоичныеДанные") Тогда 
						//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941)
						Если Не ОтправлятьВсеФайлы И Не Выборка.КОтправке Тогда 
							ВложенияНеОтмеченныеКОтправке.Добавить(Новый Структура("ИмяФайла,Размер",Выборка.ПолноеИмяФайла,пДвоичныеДанныеДляОтправки.Размер()));
							Продолжить;
						КонецЕсли;	
						//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)
						Сообщение.Вложения.Добавить(пДвоичныеДанныеДляОтправки, Выборка.ПолноеИмяФайла);						
					КонецЕсли;	
					
				
					//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-02-03 (#3997) 
					//Перенос удаление из регистра после успешной отправки
					
					//пЗаписьВФ = РегистрыСведений.ок_ВременныеФайлыПисем.СоздатьМенеджерЗаписи();
					//пЗаписьВФ.Идентификатор  = СтруктураПараметров.ИдентификаторДляВложений;
					//пЗаписьВФ.ПолноеИмяФайла = Выборка.ПолноеИмяФайла;
					//пЗаписьВФ.Прочитать();
					//Если пЗаписьВФ.Выбран() Тогда 						
					//	Попытка
					//		пЗаписьВФ.Удалить();
					//	Исключение
					//		пТекстОшибки = НСтр("ru = 'Не удалось удалить запись с идентификатором: %1 и полным именем: %2, по причине: %3'");
					//		ЗаписьЖурналаРегистрации("Отправка вложений в письмах", УровеньЖурналаРегистрации.Ошибка,МДРСВрФ,, 
					//								СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(пТекстОшибки, СтруктураПараметров.ИдентификаторДляВложений,
					//																									  Выборка.ПолноеИмяФайла,
					//																									  ОписаниеОшибки()));
					//	КонецПопытки;
					//КонецЕсли;
					//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец 2021-02-03 (#3997) 
				КонецЦикла;
			КонецЕсли;
			//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-07-18 (#3036)
		КонецЕсли;
		
		пМассивАдресовПолучателей = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтруктураПараметров.АдресПолучателя,";",Истина);
		
		Для каждого пАдресПолучателя Из пМассивАдресовПолучателей Цикл
		
			Сообщение.Получатели.Добавить(пАдресПолучателя);  		
		
		КонецЦикла; 
			
		//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-02-01 (#2975)
		Сообщение.Тема = СообщениеСтруктура.Заголовок; 
		Сообщение.Тексты.Добавить(СообщениеСтруктура.Текст + Символы.ПС + СообщениеСтруктура.Подпись, СообщениеСтруктура.ТипТекстаСообщения); 
		
		//+СБ Пискунова 10.03.2017 #2691
		Попытка
			//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103
			//ошибка типизации, значение в регистре не составного типа, поэтому неопределено не будет возвращаться никогда
			//из-за этого добавляется вложение там где его быть не должно
			//Если СообщениеСтруктура.СБ_ФормаВводаБюджета <> Неопределено Тогда
			Если ЗначениеЗаполнено(СообщениеСтруктура.СБ_ФормаВводаБюджета) Тогда
			//ОК(СофтЛаб) Вдовиченко Г.В. 20181101 №3103

				//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2018-05-07 (#2971)
				//МассивЦФО = Новый Массив;
				//МассивЦФО.Добавить(Справочники.Подразделения.НайтиПоКоду("000000114")); //Отдел по управлению недвижимостью
				////ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2017-09-29 (#2899)
				////МассивЦФО.Добавить(Справочники.Подразделения.НайтиПоКоду("000000038"));  //эксплуатация
				////ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2017-09-29 (#2899)
				//
				////МассивОбъектов = Новый Массив;
				////МассивОбъектов.Добавить(СообщениеСтруктура.СБ_ФормаВводаБюджета);
				//
				//Запрос = Новый Запрос;
				//Запрос.Текст = 
				//"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
				//|	бит_ФормаВводаБюджетаБДДС.ЦФО
				//|ИЗ
				//|	Документ.бит_ФормаВводаБюджета.БДДС КАК бит_ФормаВводаБюджетаБДДС
				//|ГДЕ
				//|	бит_ФормаВводаБюджетаБДДС.Ссылка В(&Ссылка)
				//|	И бит_ФормаВводаБюджетаБДДС.ЦФО В(&ЦФО)
				//|	И бит_ФормаВводаБюджетаБДДС.Ссылка.ВидОперации = &ВидОперации";
				//
				//Запрос.УстановитьПараметр("ВидОперации", ПредопределенноеЗначение("Перечисление.бит_БК_ВидыОперацийФормаВводаБюджета.Заявка_Инвестиционный"));
				//Запрос.УстановитьПараметр("Ссылка", СообщениеСтруктура.СБ_ФормаВводаБюджета);
				//Запрос.УстановитьПараметр("ЦФО", МассивЦФО);
				//
				//РезультатЗапроса = Запрос.Выполнить();
				//
				//Если РезультатЗапроса.Пустой() Тогда
				//	ТабДок = бит_ФормаВводаБюджетаВызовСервера.ПечатьФВБ_ПолучитьТабличныйДокумент(СообщениеСтруктура.СБ_ФормаВводаБюджета);   					
				//Иначе
				//	ТабДок = бит_ФормаВводаБюджетаВызовСервера.ПечатьФВБ_ПолучитьТабличныйДокументПечатьСтроительство(СообщениеСтруктура.СБ_ФормаВводаБюджета);
				//КонецЕсли; 
				//Заменено на:
				ТабДок = бит_ФормаВводаБюджетаВызовСервера.ПолучитьТабДокументВложения(СообщениеСтруктура.СБ_ФормаВводаБюджета);
				//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2018-05-07 (#2971)
				
				//ОКЕЙ Лобанов В.И.(СофтЛаб) Начало 2020-04-06 (#3691)
				//типФайла=ТипФайлаТабличногоДокумента.HTML;
				//Заменено на:
				типФайла = ОК_ОбщегоНазначения.ПолучитьЗначениеУниверсальнойНастройки("Визирование", "ФорматВложенийПечатныхФорм", "PDF"); 
				Попытка
					типФайла = ТипФайлаТабличногоДокумента[типФайла];
				Исключение 
					типФайла = ТипФайлаТабличногоДокумента.PDF;
				КонецПопытки;      
				//ОКЕЙ Лобанов В.И.(СофтЛаб) Конец 2020-04-06 (#3691)
				
				//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
				//ИмяФайла=СообщениеСтруктура.СБ_ФормаВводаБюджета.Номер;
				ИмяФайла = "Заявка № " + СокрЛП(СообщениеСтруктура.СБ_ФормаВводаБюджета.Номер) + " от " + Формат(СообщениеСтруктура.СБ_ФормаВводаБюджета.Дата,"ДФ=dd.MM.yyyy");
				//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
				имяФайлаСвложением = КаталогВременныхФайлов()+ПараметрыСеанса.бит_ИдентификаторСеанса+ИмяФайла+"."+(строка(типФайла));			
				ТабДок.Записать(имяФайлаСвложением,типФайла);
				//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
				//Сообщение.Вложения.Добавить(имяФайлаСвложением);
				ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаСвложением);
				Сообщение.Вложения.Добавить(ДвоичныеДанные,ИмяФайла + "." + Строка(ТипФайла));
				//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
				
				//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-09-03 (#3855)
				УдалитьФайлы(ИмяФайлаСвложением);
				//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-09-03 (#3855)
				
				//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Начало (#3499)
				ТабДок = бит_ФормаВводаБюджетаВызовСервера.ПечатьФВБ_ПолучитьТабличныйДокумент(СообщениеСтруктура.СБ_ФормаВводаБюджета,Истина);
				ИмяФайла = "Заявка № " + СокрЛП(СообщениеСтруктура.СБ_ФормаВводаБюджета.Номер) + " от " + Формат(СообщениеСтруктура.СБ_ФормаВводаБюджета.Дата,"ДФ=dd.MM.yyyy") + " eng";
				ИмяФайлаСвложением = КаталогВременныхФайлов() + ПараметрыСеанса.бит_ИдентификаторСеанса + ИмяФайла + "." + (Строка(ТипФайла));
				ТабДок.Записать(ИмяФайлаСвложением,ТипФайла);
				ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаСвложением);
				Сообщение.Вложения.Добавить(ДвоичныеДанные,ИмяФайла + "." + Строка(ТипФайла));
				//ОКЕЙ Рычаков А.С.(СофтЛаб)2019-10-07 Конец (#3499)
				
				//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-09-03 (#3855)
				УдалитьФайлы(ИмяФайлаСвложением);
				//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-09-03 (#3855)
				
			КонецЕсли;
		Исключение
		КонецПопытки;
		//-СБ Пискунова 10.03.2017 #2691
		
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-06-15 (#3778)
		ОтсортироватьВложенияСообщения(Сообщение, СтруктураПараметров);
		//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-06-15 (#3778)
		
		//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941)
		ДополнитьТекстВложениямиНеОтмеченнымиКОтправке(Сообщение, ВложенияНеОтмеченныеКОтправке);
		Для Каждого НеОтправленноеВложение Из ВложенияНеОтмеченныеКОтправке Цикл
			пЗаписьВФ = РегистрыСведений.ок_ВременныеФайлыПисем.СоздатьМенеджерЗаписи();
			пЗаписьВФ.Идентификатор  = СтруктураПараметров.ИдентификаторДляВложений;
			пЗаписьВФ.ПолноеИмяФайла = НеОтправленноеВложение.ИмяФайла;
			пЗаписьВФ.Прочитать();
			Если пЗаписьВФ.Выбран() Тогда 						
				Попытка
					пЗаписьВФ.Удалить();
				Исключение
					пТекстОшибки = НСтр("ru = 'Не удалось удалить запись с идентификатором: %1 и полным именем: %2, по причине: %3'");
					ЗаписьЖурналаРегистрации("Отправка вложений в письмах", УровеньЖурналаРегистрации.Ошибка,МДРСВрФ,, 
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(пТекстОшибки, СтруктураПараметров.ИдентификаторДляВложений,
					НеОтправленноеВложение.ИмяФайла,
					ОписаниеОшибки()));
				КонецПопытки;
			КонецЕсли;
		КонецЦикла;		
		//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)
		
		// Подключимся и отправим сформированное сообщение.
		Попытка
			
			Почта = Новый ИнтернетПочта; 
			Почта.Подключиться(ИПП); 
			Почта.Послать(Сообщение); 
			флДействиеВыполнено = Истина;
			ПротоколОтправки    = "Сообщение отправлено по адресу "
			                       +СтруктураПараметров.АдресПолучателя
								   +"  "
								   +ТекущаяДата()
								   +".";
			
		Исключение
			
			флДействиеВыполнено = Ложь;
			ПротоколОтправки    = "Сообщение  не удалось отправить по адресу "
			                       +СтруктураПараметров.АдресПолучателя
								   +"  "
								   +ТекущаяДата()
								   +" по причине "
								   +ОписаниеОшибки()
								   +".";
			
			
		КонецПопытки;
		
		Почта.Отключиться(); 
		
	КонецЕсли; 
	
	Возврат флДействиеВыполнено;
	
КонецФункции

//ОКЕЙ Поздняков А.С. (СофтЛаб) Начало 2020-06-15 (#3778)
&НаСервере
Процедура ОтсортироватьВложенияСообщения(Сообщение, СтруктураПараметров) Экспорт
	
	ОграничиватьВложенияМаксимальнымРазмером = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Ограничивать вложения максимальным размером", Ложь);
	Если НЕ ОграничиватьВложенияМаксимальнымРазмером Тогда
		Возврат;
	КонецЕсли; 
	
	НастройкаДоставки = бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Учетная запись почты согласований ЭДО", Неопределено);
	Если НЕ СтруктураПараметров.Свойство("НастройкаДоставки")
		ИЛИ СтруктураПараметров.НастройкаДоставки <> НастройкаДоставки Тогда
		Возврат;
	КонецЕсли; 
	
	МаксимальныйРазмерПисьма 	= бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Максимальный размер письма (Мб)", 5); // в Мб
	ПриоритыВложений 			= бит_БК_Общий.ПолучитьЗначениеНастройкиБК("Согласование по почте", "Приоритеты вложений письма", Новый СписокЗначений);
	
	Вложения = Сообщение.Вложения;
	
	ТаблицаДляСортировки = Новый ТаблицаЗначений();
	ТаблицаДляСортировки.Колонки.Добавить("ИмяФайла", Новый ОписаниеТипов("Строка",, Новый КвалификаторыСтроки(200)));
	ТаблицаДляСортировки.Колонки.Добавить("Размер", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(20, 5)));
	ТаблицаДляСортировки.Колонки.Добавить("Приоритет", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(5, 0)));
	
	Для каждого ТекущееВложение Из Вложения Цикл
	
		НоваяСтрокаТЗ = ТаблицаДляСортировки.Добавить();
		НоваяСтрокаТЗ.ИмяФайла = ТекущееВложение.ИмяФайла;
		НоваяСтрокаТЗ.Размер = ТекущееВложение.Данные.Размер() / 1024 / 1024; // в МБ
		НоваяСтрокаТЗ.Приоритет = 99;
		
	КонецЦикла; 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаДляСортировки.ИмяФайла КАК ИмяФайла,
		|	ТаблицаДляСортировки.Размер КАК Размер,
		|	ВЫБОР
		|		" + "КОГДА 1 = 2 ТОГДА 1" + "
		|		ИНАЧЕ ТаблицаДляСортировки.Приоритет
		|	КОНЕЦ КАК Приоритет
		|ПОМЕСТИТЬ ВТ_ТаблицаДляСортировки
		|ИЗ
		|	&ТаблицаДляСортировки КАК ТаблицаДляСортировки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаДляСортировки.ИмяФайла КАК ИмяФайла,
		|	ТаблицаДляСортировки.Размер КАК Размер,
		|	ТаблицаДляСортировки.Приоритет КАК Приоритет
		|ИЗ
		|	ВТ_ТаблицаДляСортировки КАК ТаблицаДляСортировки
		|
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет,
		|	Размер";
	
	Для Инд = 1 По ПриоритыВложений.Количество() Цикл
	
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "КОГДА 1 = 2 ТОГДА 1", "КОГДА 1 = 2 ТОГДА 1
			|		КОГДА ТаблицаДляСортировки.ИмяФайла ПОДОБНО """ + ПриоритыВложений[Инд-1].Значение + """ ТОГДА " + Инд);
	
	КонецЦикла; 
	
	МассивИменФайловДляВключенияВСообщение = Новый Массив;
	НакопленныйРазмерПисьма = 0;
	
	Запрос.Параметры.Вставить("ТаблицаДляСортировки", ТаблицаДляСортировки);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		Если (НакопленныйРазмерПисьма + ВыборкаДетальныеЗаписи.Размер) > МаксимальныйРазмерПисьма Тогда
			Прервать;
		КонецЕсли;
		
		МассивИменФайловДляВключенияВСообщение.Добавить(ВыборкаДетальныеЗаписи.ИмяФайла);
		НакопленныйРазмерПисьма = НакопленныйРазмерПисьма + ВыборкаДетальныеЗаписи.Размер;
		
	КонецЦикла;
	
	МассивВложенийДляУдаления = Новый Массив;
	ТекстОбУдаленныхФайловВоВложении = "";
	Для каждого ТекущееВложение Из Вложения Цикл
	
		Если МассивИменФайловДляВключенияВСообщение.Найти(ТекущееВложение.ИмяФайла) = Неопределено Тогда
			ТекстОбУдаленныхФайловВоВложении = ТекстОбУдаленныхФайловВоВложении + "Файл """ + ТекущееВложение.ИмяФайла + """ был удален из вложений из-за превышения максимального размера вложений в сообщении. (" + Формат(ТекущееВложение.Данные.Размер() / 1024 / 1024, "ЧДЦ=2; ЧГ=0") + "Мб.)" + Символы.ПС;
			МассивВложенийДляУдаления.Добавить(ТекущееВложение);
		КонецЕсли; 
	
	КонецЦикла; 
	
	Для каждого ТекущееВложениеДляУдаления Из МассивВложенийДляУдаления Цикл
		Вложения.Удалить(ТекущееВложениеДляУдаления);
	КонецЦикла;
	
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941) вынес в отдельную процедуру для вызова из другого места
	//Если ТекстОбУдаленныхФайловВоВложении <> "" Тогда
	//	Если Сообщение.Тексты.Количество() > 0 
	//		И Сообщение.Тексты[0].ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
	//		ТекстОбУдаленныхФайловВоВложении 		= ТекстОбУдаленныхФайловВоВложении + "При возникновении вопросов, просьба обращаться к ответственному бухгалтеру" + Символы.ПС;
	//		ТекстОбУдаленныхФайловВоВложении 		= СтрЗаменить(ТекстОбУдаленныхФайловВоВложении, Символы.ПС, "<BR/>");
	//		ТекстОбУдаленныхФайловВоВложенииHTML 	= "<P><span style=""color: #ff0000;"">%1</span>";
	//		ТекстОбУдаленныхФайловВоВложенииHTML 	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОбУдаленныхФайловВоВложенииHTML, ТекстОбУдаленныхФайловВоВложении);
	//		
	//		Сообщение.Тексты[0].Текст = Сообщение.Тексты[0].Текст + "<BR/>" + ТекстОбУдаленныхФайловВоВложенииHTML;
	//	Иначе
	//		ТекстОбУдаленныхФайловВоВложении = ТекстОбУдаленныхФайловВоВложении + "При возникновении вопросов, просьба обращаться к ответственному бухгалтеру" + Символы.ПС;
	//		Сообщение.Тексты.Добавить(ТекстОбУдаленныхФайловВоВложении, ТипТекстаПочтовогоСообщения.ПростойТекст);
	//	КонецЕсли; 
	//КонецЕсли;
	ДобавитьВСообщениеТекстОбУдаленныхВложениях(Сообщение, ТекстОбУдаленныхФайловВоВложении);
	//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)
	
КонецПроцедуры
//ОКЕЙ Поздняков А.С. (СофтЛаб) Конец 2020-06-15 (#3778)

//ОКЕЙ Сафронов А.А. (СофтЛаб) Начало 2020-12-07 (#3941)
Процедура ДобавитьВСообщениеТекстОбУдаленныхВложениях(Сообщение, ТекстОбУдаленныхФайловВоВложении)
	
	Если ТекстОбУдаленныхФайловВоВложении <> "" Тогда
		Если Сообщение.Тексты.Количество() > 0 
			И Сообщение.Тексты[0].ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
			ТекстОбУдаленныхФайловВоВложении 		= ТекстОбУдаленныхФайловВоВложении + "При возникновении вопросов, просьба обращаться к ответственному бухгалтеру" + Символы.ПС;
			ТекстОбУдаленныхФайловВоВложении 		= СтрЗаменить(ТекстОбУдаленныхФайловВоВложении, Символы.ПС, "<BR/>");
			ТекстОбУдаленныхФайловВоВложенииHTML 	= "<P><span style=""color: #ff0000;"">%1</span>";
			ТекстОбУдаленныхФайловВоВложенииHTML 	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОбУдаленныхФайловВоВложенииHTML, ТекстОбУдаленныхФайловВоВложении);
			
			Сообщение.Тексты[0].Текст = Сообщение.Тексты[0].Текст + "<BR/>" + ТекстОбУдаленныхФайловВоВложенииHTML;
		Иначе
			ТекстОбУдаленныхФайловВоВложении = ТекстОбУдаленныхФайловВоВложении + "При возникновении вопросов, просьба обращаться к ответственному бухгалтеру" + Символы.ПС;
			Сообщение.Тексты.Добавить(ТекстОбУдаленныхФайловВоВложении, ТипТекстаПочтовогоСообщения.ПростойТекст);
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьТекстВложениямиНеОтмеченнымиКОтправке(Сообщение, ВложенияНеОтмеченныеКОтправке)
	ТекстОбУдаленныхФайловВоВложении = "";
	Для каждого ТекущееВложение Из ВложенияНеОтмеченныеКОтправке Цикл
		ТекстОбУдаленныхФайловВоВложении = ТекстОбУдаленныхФайловВоВложении + "Файл """ + ТекущееВложение.ИмяФайла + """ был удален из вложений из-за превышения максимального размера вложений в сообщении. (" + Формат(ТекущееВложение.Размер / 1024 / 1024, "ЧДЦ=2; ЧГ=0") + "Мб.)" + Символы.ПС;
	КонецЦикла; 
	ДобавитьВСообщениеТекстОбУдаленныхВложениях(Сообщение, ТекстОбУдаленныхФайловВоВложении);
КонецПроцедуры	
//ОКЕЙ Сафронов А.А. (СофтЛаб) Конец 2020-12-07 (#3941)

#КонецОбласти

#КонецЕсли
